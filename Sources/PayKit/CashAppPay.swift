//
//  PayKit.swift
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

public class CashAppPay {

    public static let version = "0.6.3"

    public static let RedirectNotification: Notification.Name = Notification.Name("CashAppPayRedirect")

    let stateMachine: StateMachine

    private let networkManager: NetworkManager

    public convenience init(clientID: String, endpoint: Endpoint = .production) {
        let networkManager = NetworkManager(clientID: clientID, endpoint: endpoint)
        let analytics = EventStream2(
            appName: EventStream2.appName,
            commonParameters: [
                EventStream2.CommonFields.clientID.rawValue: clientID,
                EventStream2.CommonFields.platform.rawValue: "iOS",
                EventStream2.CommonFields.sdkVersion.rawValue: CashAppPay.version,
                EventStream2.CommonFields.clientUA.rawValue: UserAgent.userAgent,
                EventStream2.CommonFields.environment.rawValue: endpoint.analyticsField,
            ],
            store: AnalyticsDataSource(),
            client: AnalyticsClient(restService: ResilientRESTService(), endpoint: endpoint.analyticsEndpoint)
        )

        let stateMachine = StateMachine(networkManager: networkManager, analyticsService: analytics)
        self.init(stateMachine: stateMachine, networkManager: networkManager, endpoint: endpoint)
    }

    init(stateMachine: StateMachine, networkManager: NetworkManager, endpoint: Endpoint) {
        self.stateMachine = stateMachine
        self.networkManager = networkManager
        self.endpoint = endpoint
    }

    public enum Endpoint {
        case production
        case sandbox
        case staging
    }

    /// The endpoint that the requests are routed to
    public let endpoint: Endpoint

    /// Fetch an existing CustomerRequest by ID.
    public func retrieveCustomerRequest(
        id: String,
        completion: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        networkManager.retrieveCustomerRequest(id: id, completionHandler: completion)
    }

    /// Create a customer request. Registered observers are notified of state changes as the request proceeds.
    public func createCustomerRequest(
        params: CreateCustomerRequestParams
    ) {
        stateMachine.state = .creatingCustomerRequest(params)
    }

    /// Update an existing customer request. Registered observers are notified of state changes as the request proceeds.
    public func updateCustomerRequest(
        _ request: CustomerRequest,
        with params: UpdateCustomerRequestParams
    ) {
        switch request.status {
        case .APPROVED, .DECLINED:
            stateMachine.state = .integrationError(.terminalStateError)
        case .PENDING, .PROCESSING:
            stateMachine.state = .updatingCustomerRequest(request: request, params: params)
        }
    }

    public enum AuthorizationMethod {
        case DEEPLINK
        // case QR_CODE -- future
    }

    /// Authorize an existing customer request.
    /// Registered observers are notified of state changes as the request proceeds.
    public func authorizeCustomerRequest(
        _ request: CustomerRequest,
        method: AuthorizationMethod = .DEEPLINK
    ) {
        switch request.status {
        case .DECLINED:
            stateMachine.state = .integrationError(.terminalStateError)
        case .APPROVED:
            stateMachine.state = .redirecting(request)
        case .PENDING, .PROCESSING:
            if request.authFlowTriggers?.isExpired() == false {
                stateMachine.state = .redirecting(request)
            } else {
                stateMachine.state = .refreshing(request)
            }
        }
    }
}

public enum CashAppPayState: Equatable {
    /// Ready for a Create Customer Request to be initiated.
    case notStarted
    /// CustomerRequest is being created. For information only.
    case creatingCustomerRequest(CreateCustomerRequestParams)
    /// CustomerRequest is being updated. For information only.
    case updatingCustomerRequest(request: CustomerRequest, params: UpdateCustomerRequestParams)
    /// CustomerRequest has been created, waiting for customer to press "Pay with Cash App Pay" button.
    case readyToAuthorize(CustomerRequest)
    /// SDK is redirecting to Cash App for authorization. Show loading indicator if desired.
    case redirecting(CustomerRequest)
    /// SDK is retrieving authorized CustomerRequest. Show loading indicator if desired.
    case polling(CustomerRequest)
    /// CustomerRequest was declined. Update UI to tell customer to try again.
    case declined(CustomerRequest)
    /// CustomerRequest was approved. Update UI to show payment info or $cashtag.
    case approved(request: CustomerRequest, grants: [CustomerRequest.Grant])
    /// CustomerRequest is being refreshed as a result of the AuthFlowTriggers expiring.
    /// Show loading indicator if desired.
    case refreshing(CustomerRequest)
    /// An error with the Cash App Pay API that can manifest at runtime.
    /// If an `APIError` is received, the integration is degraded and Cash App Pay functionality
    /// should be temporarily removed from the app's UI.
    case apiError(APIError)
    /// An error in the integration that should be resolved before shipping to production.
    /// Examples include authorization issues, incorrect brand IDs, validation errors, etc.
    case integrationError(IntegrationError)
    /// A networking error, likely due to poor internet connectivity.
    case networkError(NetworkError)
    /// An unexpected error. Please report any errors of this kind (and what caused them) to Cash App Developer Support.
    case unexpectedError(UnexpectedError)
}

public protocol CashAppPayObserver: AnyObject {
    func stateDidChange(to state: CashAppPayState)
}

public extension CashAppPay {
    func addObserver(_ observer: CashAppPayObserver) {
        stateMachine.addObserver(observer)
    }

    func removeObserver(_ observer: CashAppPayObserver) {
        stateMachine.removeObserver(observer)
    }
}
