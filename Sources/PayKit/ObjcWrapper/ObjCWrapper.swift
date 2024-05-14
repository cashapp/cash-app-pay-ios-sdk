//
//  ObjCWrapper.swift
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

@objc public protocol CAPCashAppPayObserver: NSObjectProtocol {
    func stateDidChange(to state: CAPCashAppPayState)
}

@objc(CAPCashAppPay)
public final class ObjCWrapper: NSObject {
    @objc public static var sdkVersion: String {
        CashAppPay.version
    }

    @objc public static var RedirectNotification: Notification.Name {
        CashAppPay.RedirectNotification
    }

    private let cashAppPay: CashAppPay
    private var observations = [ObjectIdentifier: Observation]()

    @objc public var endpoint: CAPEndpoint {
        cashAppPay.endpoint.capEndpoint
    }

    @objc public convenience init(clientID: String, endpoint: CAPEndpoint = .production) {
        let cashAppPay = CashAppPay(
            clientID: clientID,
            endpoint: endpoint.endpoint
        )
        self.init(cashAppPay: cashAppPay)
    }

    init(cashAppPay: CashAppPay) {
        self.cashAppPay = cashAppPay
        super.init()
        cashAppPay.addObserver(self)
    }

    @objc public func retrieveCustomerRequest(
        id: String,
        completion: @escaping (CAPCustomerRequest?, NSError?) -> Void
    ) {
        cashAppPay.retrieveCustomerRequest(id: id) { result in
            switch result {
            case .success(let customerRequest):
                let capCustomerRequest = CAPCustomerRequest(customerRequest: customerRequest)
                completion(capCustomerRequest, nil)
            case .failure(let error):
                completion(nil, error.cashAppPayObjCError)
            }
        }
    }

    @objc public func createCustomerRequest(
        params: CAPCreateCustomerRequestParams
    ) {
        cashAppPay.createCustomerRequest(params: params.createCustomerRequestParams)
    }

    @objc public func updateCustomerRequest(
        _ request: CAPCustomerRequest,
        with params: CAPUpdateCustomerRequestParams
    ) {
        cashAppPay.updateCustomerRequest(
            request.customerRequest,
            with: params.updateCustomerRequestParams
        )
    }

    @objc public func authorizeCustomerRequest(
        _ request: CAPCustomerRequest
    ) {
        cashAppPay.authorizeCustomerRequest(request.customerRequest)
    }
}

// MARK: - Observations

extension ObjCWrapper {
    private struct Observation {
        weak var observer: CAPCashAppPayObserver?
    }

    @objc public func addObserver(_ observer: CAPCashAppPayObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    @objc func removeObserver(_ observer: CAPCashAppPayObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}

// MARK: - CashAppPayObserver

extension ObjCWrapper: CashAppPayObserver {
    public func stateDidChange(to state: CashAppPayState) {
        for (id, observation) in observations {
            // Clean up any observer that is no longer in memory
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.stateDidChange(to: state.asCAPCashAppPayState)
        }
    }
}

// MARK: - CAPEndpoint

@objc public enum CAPEndpoint: Int {
    case production
    case sandbox
    case staging

    var endpoint: CashAppPay.Endpoint {
        switch self {
        case .production: return .production
        case .sandbox: return .sandbox
        case .staging: return .staging
        }
    }
}

private extension CashAppPay.Endpoint {
    var capEndpoint: CAPEndpoint {
        switch self {
        case .production: return .production
        case .sandbox: return .sandbox
        case .staging: return .staging
        }
    }
}
