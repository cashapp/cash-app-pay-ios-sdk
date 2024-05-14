//
//  Errors+ObjCTests.swift
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

// MARK: - APIError

public let CAPErrorDomain = "com.squareup.cashapppay.error"

@objcMembers public final class CAPApiError: NSError {

    // MARK: - Properties

    let apiError: APIError

    // MARK: - Public Properties

    public var category: CAPApiErrorCategory {
        apiError.category.capApiErrorCategory
    }

    public override var code: Int {
        apiError.code.capApiErrorCode.rawValue
    }

    public var detail: String? {
        apiError.detail
    }

    public var field: String? {
        apiError.field
    }

    // MARK: - Init

    init(apiError: APIError) {
        self.apiError = apiError
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension APIError.Category {
    var capApiErrorCategory: CAPApiErrorCategory {
        switch self {
        case .API_ERROR: return .API_ERROR
        }
    }
}

@objc public enum CAPApiErrorCategory: Int {
    case API_ERROR
}

extension APIError.ErrorCode {
    var capApiErrorCode: CAPApiErrorCode {
        switch self {
        case .INTERNAL_SERVER_ERROR:
            return .INTERNAL_SERVER_ERROR
        case .SERVICE_UNAVAILABLE:
            return .SERVICE_UNAVAILABLE
        case .GATEWAY_TIMEOUT:
            return .GATEWAY_TIMEOUT
        }
    }
}

@objc public enum CAPApiErrorCode: Int {
    case INTERNAL_SERVER_ERROR
    case SERVICE_UNAVAILABLE
    case GATEWAY_TIMEOUT
}

// MARK: - IntegrationError

@objcMembers public final class CAPIntegrationError: NSError {

    // MARK: - Properties

    let integrationError: IntegrationError

    // MARK: - Public Properties

    public var category: CAPIntegrationErrorCategory {
        integrationError.category.capIntegrationErrorCategory
    }

    public override var code: Int {
        integrationError.code.capIntegrationErrorCode.rawValue
    }

    public var detail: String? {
        integrationError.detail
    }
    public var field: String? {
        integrationError.field
    }

    // MARK: - Init

    init(integrationError: IntegrationError) {
        self.integrationError = integrationError
        super.init(domain: CAPErrorDomain, code: 1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IntegrationError.Category {
    var capIntegrationErrorCategory: CAPIntegrationErrorCategory {
        switch self {
        case .AUTHENTICATION_ERROR:
            return .AUTHENTICATION_ERROR
        case .BRAND_ERROR:
            return .BRAND_ERROR
        case .MERCHANT_ERROR:
            return .MERCHANT_ERROR
        case .INVALID_REQUEST_ERROR:
            return .INVALID_REQUEST_ERROR
        case .RATE_LIMIT_ERROR:
            return .RATE_LIMIT_ERROR
        }
    }
}

@objc public enum CAPIntegrationErrorCategory: Int {
    case AUTHENTICATION_ERROR
    case BRAND_ERROR
    case MERCHANT_ERROR
    case INVALID_REQUEST_ERROR
    case RATE_LIMIT_ERROR
}

extension IntegrationError.ErrorCode {
    var capIntegrationErrorCode: CAPIntegrationErrorCode {
        switch self {
        case .UNAUTHORIZED:
            return .UNAUTHORIZED
        case .CLIENT_DISABLED:
            return .CLIENT_DISABLED
        case .FORBIDDEN:
            return .FORBIDDEN
        case .VALUE_TOO_LONG:
            return .VALUE_TOO_LONG
        case .VALUE_TOO_SHORT:
            return .VALUE_TOO_SHORT
        case .VALUE_EMPTY:
            return .VALUE_EMPTY
        case .VALUE_REGEX_MISMATCH:
            return .VALUE_REGEX_MISMATCH
        case .INVALID_URL:
            return .INVALID_URL
        case .VALUE_TOO_HIGH:
            return .VALUE_TOO_HIGH
        case .VALUE_TOO_LOW:
            return .VALUE_TOO_LOW
        case .ARRAY_LENGTH_TOO_LONG:
            return .ARRAY_LENGTH_TOO_LONG
        case .ARRAY_LENGTH_TOO_SHORT:
            return .ARRAY_LENGTH_TOO_SHORT
        case .INVALID_ARRAY_TYPE:
            return .INVALID_ARRAY_TYPE
        case .NOT_FOUND:
            return .NOT_FOUND
        case .CONFLICT:
            return .CONFLICT
        case .INVALID_STATE_TRANSITION:
            return .INVALID_STATE_TRANSITION
        case .CLIENT_NOT_FOUND:
            return .CLIENT_NOT_FOUND
        case .RATE_LIMITED:
            return .RATE_LIMITED
        case .BRAND_NOT_FOUND:
            return .BRAND_NOT_FOUND
        case .MERCHANT_MISSING_ADDRESS_OR_SITE:
            return .MERCHANT_MISSING_ADDRESS_OR_SITE
        }
    }
}

@objc public enum CAPIntegrationErrorCode: Int {
    // Authentication Errors
    case UNAUTHORIZED
    case CLIENT_DISABLED
    case FORBIDDEN

    // Invalid Request Errors
    case VALUE_TOO_LONG
    case VALUE_TOO_SHORT
    case VALUE_EMPTY
    case VALUE_REGEX_MISMATCH
    case INVALID_URL
    case VALUE_TOO_HIGH
    case VALUE_TOO_LOW
    case ARRAY_LENGTH_TOO_LONG
    case ARRAY_LENGTH_TOO_SHORT
    case INVALID_ARRAY_TYPE
    case NOT_FOUND
    case CONFLICT
    case INVALID_STATE_TRANSITION
    case CLIENT_NOT_FOUND

    // Rate Limit Errors
    case RATE_LIMITED

    // Brand Errors
    case BRAND_NOT_FOUND

    // Merchant Errors
    case MERCHANT_MISSING_ADDRESS_OR_SITE
}

// MARK: - UnexpectedError

@objcMembers public final class CAPUnexpectedError: NSError {

    // MARK: - Properties

    let unexpectedError: UnexpectedError

    // MARK: - Public Properties

    public var category: String {
        unexpectedError.category
    }

    public var codeMessage: String {
        unexpectedError.code
    }

    public var detail: String? {
        unexpectedError.detail
    }

    public var field: String? {
        unexpectedError.field
    }

    // MARK: - Init

    init(unexpectedError: UnexpectedError) {
        self.unexpectedError = unexpectedError
        super.init(domain: CAPErrorDomain, code: 1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Network Error

@objc public final class CAPNetworkErrorNoResponse: NSError {}

@objc public final class CAPNetworkErrorNilData: NSError {
    @objc public var response: HTTPURLResponse

    init(response: HTTPURLResponse) {
        self.response = response
        super.init(domain: CAPErrorDomain, code: NSURLErrorCannotParseResponse)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc public final class CAPNetworkErrorInvalidJSON: NSError {
    @objc public var data: Data

    init(data: Data) {
        self.data = data
        super.init(domain: "Invalid JSON", code: -1)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Error Extensions

extension Error {
    var cashAppPayObjCError: NSError? {
        switch self {
        case let apiError as APIError:
            return CAPApiError(apiError: apiError)
        case let integrationError as IntegrationError:
            return CAPIntegrationError(integrationError: integrationError)
        case let unexpectedError as UnexpectedError:
            return CAPUnexpectedError(unexpectedError: unexpectedError)
        case let networkError as NetworkError:
            switch networkError {
            case .noResponse:
                return CAPNetworkErrorNoResponse()
            case .nilData(let response):
                return CAPNetworkErrorNilData(response: response)
            case .invalidJSON(let json):
                return CAPNetworkErrorInvalidJSON(data: json)
            case .systemError(let error):
                return error
            }
        default:
            return nil
        }
    }
}
