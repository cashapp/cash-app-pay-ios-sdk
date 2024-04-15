//
//  CashAppPayState+ObjC.swift
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

@objc open class CAPCashAppPayState: NSObject {
    override init() {
        super.init()
    }
}

/// Ready for a Create Customer Request to be initiated.
@objc public final class CAPCashAppPayStateNotStarted: CAPCashAppPayState {

    override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        return object is CAPCashAppPayStateNotStarted
    }
}

/// CustomerRequest is being created. For information only.
@objcMembers public final class CAPCashAppPayStateCreatingCustomerRequest: CAPCashAppPayState {
    public let params: CAPCreateCustomerRequestParams

    // MARK: - Init

    init(params: CAPCreateCustomerRequestParams) {
        self.params = params
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateCreatingCustomerRequest else {
            return false
        }
        return params == otherObject.params
    }
}

/// CustomerRequest is being updated. For information only.
@objcMembers public final class CAPCashAppPayStateUpdatingCustomerRequest: CAPCashAppPayState {
    public let request: CAPCustomerRequest
    public let params: CAPUpdateCustomerRequestParams

    init(request: CAPCustomerRequest, params: CAPUpdateCustomerRequestParams) {
        self.request = request
        self.params = params
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateUpdatingCustomerRequest else {
            return false
        }
        return request == otherObject.request && params == otherObject.params
    }
}

/// CustomerRequest has been created, waiting for customer to press "Pay with Cash App Pay" button.
@objcMembers public final class CAPCashAppPayStateReadyToAuthorize: CAPCashAppPayState {
    public let request: CAPCustomerRequest

    init(request: CAPCustomerRequest) {
        self.request = request
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateReadyToAuthorize else {
            return false
        }
        return request == otherObject.request
    }
}

/// SDK is redirecting to Cash App for authorization. Show loading indicator if desired.
@objcMembers public final class CAPCashAppPayStateRedirecting: CAPCashAppPayState {
    public let request: CAPCustomerRequest

    init(request: CAPCustomerRequest) {
        self.request = request
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateRedirecting else {
            return false
        }
        return request == otherObject.request
    }
}

/// SDK is redirecting to Cash App for authorization. Show loading indicator if desired.
@objcMembers public final class CAPCashAppPayStatePolling: CAPCashAppPayState {
    public let request: CAPCustomerRequest

    init(request: CAPCustomerRequest) {
        self.request = request
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStatePolling else {
            return false
        }
        return request == otherObject.request
    }
}

/// SDK is redirecting to Cash App for authorization. Show loading indicator if desired.
@objcMembers public final class CAPCashAppPayStateDeclined: CAPCashAppPayState {
    public let request: CAPCustomerRequest

    init(request: CAPCustomerRequest) {
        self.request = request
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateDeclined else {
            return false
        }
        return request == otherObject.request
    }
}

/// CustomerRequest was approved. Update UI to show payment info or $cashtag.
@objcMembers public final class CAPCashAppPayStateApproved: CAPCashAppPayState {
    public let request: CAPCustomerRequest
    public let grants: [CAPCustomerRequestGrant]

    init(request: CAPCustomerRequest, grants: [CAPCustomerRequestGrant]) {
        self.request = request
        self.grants = grants
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateApproved else {
            return false
        }
        return request == otherObject.request && grants == otherObject.grants
    }
}

/// CustomerRequest is being refreshed as a result of the AuthFlowTriggers expiring.
/// Show loading indicator if desired.
@objcMembers public final class CAPCashAppPayStateRefreshing: CAPCashAppPayState {
    public let request: CAPCustomerRequest

    init(request: CAPCustomerRequest) {
        self.request = request
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateRefreshing else {
            return false
        }
        return request == otherObject.request
    }
}

/// An error with the Cash App Pay API that can manifest at runtime.
/// If an `APIError` is received, the integration is degraded and Cash App Pay functionality
/// should be temporarily removed from the app's UI.
@objcMembers public final class CAPCashAppPayStateAPIError: CAPCashAppPayState {
    public let apiError: APIError

    init(apiError: APIError) {
        self.apiError = apiError
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateAPIError else {
            return false
        }
        return apiError == otherObject.apiError
    }
}

/// An error in the integration that should be resolved before shipping to production.
/// Examples include authorization issues, incorrect brand IDs, validation errors, etc.
@objcMembers public final class CAPCashAppPayStateIntegrationError: CAPCashAppPayState {
    public let integrationError: IntegrationError

    init(integrationError: IntegrationError) {
        self.integrationError = integrationError
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateIntegrationError else {
            return false
        }
        return integrationError == otherObject.integrationError
    }
}

/// A networking error, likely due to poor internet connectivity.
@objcMembers public final class CAPCashAppPayStateNetworkError: CAPCashAppPayState {
    public let networkError: NSError

    init(networkError: NSError) {
        self.networkError = networkError
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateNetworkError else {
            return false
        }
        return networkError == otherObject.networkError
    }
}

/// An unexpected error. Please report any errors of this kind (and what caused them) to Cash App Developer Support.
@objcMembers public final class CAPCashAppPayStateUnexpectedError: CAPCashAppPayState {
    public let unexpectedError: UnexpectedError

    init(unexpectedError: UnexpectedError) {
        self.unexpectedError = unexpectedError
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherObject = object as? CAPCashAppPayStateUnexpectedError else {
            return false
        }
        return unexpectedError == otherObject.unexpectedError
    }
}

extension CashAppPayState {
    var asCAPCashAppPayState: CAPCashAppPayState {
        switch self {
        case .notStarted:
            return CAPCashAppPayStateNotStarted()
        case .creatingCustomerRequest(let createCustomerRequestParams):
            return CAPCashAppPayStateCreatingCustomerRequest(
                params: .init(createCustomerRequestParams: createCustomerRequestParams)
            )
        case .updatingCustomerRequest(let request, let params):
            return CAPCashAppPayStateUpdatingCustomerRequest(
                request: .init(customerRequest: request),
                params: .init(updateCustomerRequestParams: params)
            )
        case .readyToAuthorize(let customerRequest):
            return CAPCashAppPayStateReadyToAuthorize(
                request: .init(customerRequest: customerRequest)
            )
        case .redirecting(let customerRequest):
            return CAPCashAppPayStateRedirecting(
                request: .init(customerRequest: customerRequest)
            )
        case .polling(let customerRequest):
            return CAPCashAppPayStatePolling(
                request: .init(customerRequest: customerRequest)
            )
        case .declined(let customerRequest):
            return CAPCashAppPayStateDeclined(
                request: .init(customerRequest: customerRequest)
            )
        case .approved(let request, let grants):
            return CAPCashAppPayStateApproved(
                request: .init(customerRequest: request),
                grants: grants.map(CAPCustomerRequestGrant.init(grant:))
            )
        case .refreshing(let customerRequest):
            return CAPCashAppPayStateRefreshing(
                request: .init(customerRequest: customerRequest)
            )
        case .apiError(let apiError):
            return CAPCashAppPayStateAPIError(
                apiError: apiError
            )
        case .integrationError(let integrationError):
            return CAPCashAppPayStateIntegrationError(
                integrationError: integrationError
            )
        case .networkError(.noResponse):
            return CAPCashAppPayStateNetworkError(
                networkError: CAPNetworkErrorNoResponse()
            )
        case .networkError(.nilData(let response)):
            return CAPCashAppPayStateNetworkError(
                networkError: CAPNetworkErrorNilData(response: response)
            )
        case .networkError(.invalidJSON(let data)):
            return CAPCashAppPayStateNetworkError(
                networkError: CAPNetworkErrorInvalidJSON(data: data)
            )
        case .networkError(.systemError(let error)):
            return CAPCashAppPayStateNetworkError(
                networkError: error
            )
        case .unexpectedError(let unexpectedError):
            return CAPCashAppPayStateUnexpectedError(
                unexpectedError: unexpectedError
            )
        }
    }
}
