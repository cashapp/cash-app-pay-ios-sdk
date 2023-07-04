//
//  StateMachine.swift
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import UIKit

class StateMachine {

    private var observations = [ObjectIdentifier: Observation]()

    let networkManager: NetworkManager
    let analyticsService: AnalyticsService

    var notificationObserver: NSObjectProtocol?
    var pollingTimer: Timer?

    var state: CashAppPayState = .notStarted {
        didSet {
            stateDidChange(to: state, from: oldValue)
        }
    }

    init(networkManager: NetworkManager, analyticsService: AnalyticsService) {
        self.networkManager = networkManager
        self.analyticsService = analyticsService
        NotificationCenter.default.addObserver(
            forName: CashAppPay.RedirectNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let self else { return }

            // Only .redirecting and .readyToAuthorize can advance to .polling when a redirect is received.
            // Redirects should be ignored otherwise, to preserve existing SDK state.
            if case let .redirecting(customerRequest) = self.state {
                self.state = .polling(customerRequest)
            } else if case let .readyToAuthorize(customerRequest) = self.state {
                self.state = .polling(customerRequest)
            }
        }
        analyticsService.track(InitializationEvent())
    }

    deinit {
        cleanUpSideEffectsFor(state: .notStarted)
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func stateDidChange(to state: CashAppPayState, from oldState: CashAppPayState) {
        // Clear polling timer and observer if necessary.
        cleanUpSideEffectsFor(state: state)

        switch state {
        case .notStarted:
            break
        case .creatingCustomerRequest(let params):
            networkManager.createCustomerRequest(params: params) { [weak self] (result) in
                switch result {
                case let .success(customerRequest):
                    self?.state = .readyToAuthorize(customerRequest)
                case let .failure(error):
                    self?.setErrorState(error)
                }
            }
            analyticsService.track(CustomerRequestEvent.createRequest(params: params))
        case .updatingCustomerRequest(let request, let params):
            networkManager.updateCustomerRequest(request, with: params) { [weak self] result in
                switch result {
                case let .success(customerRequest):
                    self?.state = .readyToAuthorize(customerRequest)
                case let .failure(error):
                    self?.setErrorState(error)
                }
            }
            analyticsService.track(CustomerRequestEvent.updateRequest(request: request, params: params))
        case .redirecting(let customerRequest):
            analyticsService.track(CustomerRequestEvent.redirect(request: customerRequest))
            guard let mobileURL = customerRequest.authFlowTriggers?.mobileURL else {
                self.setErrorState(UnexpectedError.noRedirectURLFor(customerRequest))
                return
            }

            notificationObserver = NotificationCenter.default.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: nil
            ) { [weak self] _ in
                guard let self else { return }
                if case let .redirecting(customerRequest) = state {
                    self.state = .polling(customerRequest)
                }
            }
            UIApplication.shared.open(mobileURL)
        case .polling(let customerRequest):
            analyticsService.track(CustomerRequestEvent.polling(request: customerRequest))
            let pollingTimer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
                guard let self else { return }
                self.networkManager.retrieveCustomerRequest(id: customerRequest.id) { [weak self] (result) in
                    guard let self else { return }
                    switch result {
                    case let .success(customerRequest):
                        switch customerRequest.status {
                        case .APPROVED:
                            guard let grants = customerRequest.grants else {
                                self.state = .declined(customerRequest)
                                return
                            }
                            self.state = .approved(request: customerRequest, grants: grants)
                        case .DECLINED:
                            self.state = .declined(customerRequest)
                        case .PENDING, .PROCESSING:
                            // Continue polling.
                            break
                        }
                    case let .failure(error):
                        self.setErrorState(error)
                    }
                }
            })
            RunLoop.current.add(pollingTimer, forMode: .common)
            self.pollingTimer = pollingTimer
            pollingTimer.fire()
        case .readyToAuthorize(let customerRequest):
            analyticsService.track(CustomerRequestEvent.readyToAuthorize(request: customerRequest))
        case .declined(let customerRequest):
            analyticsService.track(CustomerRequestEvent.declined(request: customerRequest))
        case .approved(let customerRequest, let grants):
            analyticsService.track(CustomerRequestEvent.approved(request: customerRequest, grants: grants))
        case .refreshing(let customerRequest):
            analyticsService.track(CustomerRequestEvent.refreshing(request: customerRequest))
            networkManager.retrieveCustomerRequest(
                id: customerRequest.id,
                retryPolicy: .exponential(delay: 3, maximumNumberOfAttempts: 3)
            ) { [weak self] result in
                switch result {
                case .success(let refreshedCustomerRequest):
                    self?.state = .redirecting(refreshedCustomerRequest)
                case .failure(let error):
                    self?.setErrorState(error)
                }
            }
        case .apiError(let error):
            analyticsService.track(CustomerRequestEvent.error(error))
        case .integrationError(let error):
            analyticsService.track(CustomerRequestEvent.error(error))
        case .networkError(let error):
            analyticsService.track(CustomerRequestEvent.error(error))
        case .unexpectedError(let error):
            analyticsService.track(CustomerRequestEvent.error(error))
        }

        for (id, observation) in observations {
            // Clean up any observer that is no longer in memory
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            observer.stateDidChange(to: state)
        }
    }

    func setErrorState(_ error: Error) {
        if let apiError = error as? APIError {
            state = .apiError(apiError)
        } else if let integrationError = error as? IntegrationError {
            state = .integrationError(integrationError)
        } else if let networkError = error as? NetworkError {
            state = .networkError(networkError)
        } else if let unexpectedError = error as? UnexpectedError {
            state = .unexpectedError(unexpectedError)
        } else {
            state = .unexpectedError(.unknownErrorFor(error))
        }
    }

    func cleanUpSideEffectsFor(state: CashAppPayState) {
        // If we're in any state other than .polling, invalidate the timer.
        if case .polling = state {
            // do nothing
        } else {
            pollingTimer?.invalidate()
            pollingTimer = nil
        }

        // If we're in any state other than .redirecting, stop handling applicationWillForeground notifications.
        if case .redirecting = state {
            // do nothing
        } else {
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
                notificationObserver = nil
            }
        }

    }
}

extension StateMachine {
    struct Observation {
        weak var observer: CashAppPayObserver?
    }

    func addObserver(_ observer: CashAppPayObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
        analyticsService.track(ListenerEvent(listenerUID: id.debugDescription, isAdded: true))
    }

    func removeObserver(_ observer: CashAppPayObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
        analyticsService.track(ListenerEvent(listenerUID: id.debugDescription, isAdded: false))
    }
}
