//
//  Errors.swift
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

public struct APIError: Error, Codable, Equatable {
    let category: Category
    let code: ErrorCode
    let detail: String?
    let field: String?

    enum Category: String, Codable, Equatable {
        case API_ERROR
    }

    enum ErrorCode: String, Codable, Equatable {
        case INTERNAL_SERVER_ERROR
        case SERVICE_UNAVAILABLE
        case GATEWAY_TIMEOUT
    }
}

public struct IntegrationError: Error, Codable, Equatable {
    let category: Category
    let code: ErrorCode
    let detail: String?
    let field: String?

    enum Category: String, Codable, Equatable {
        case AUTHENTICATION_ERROR
        case BRAND_ERROR
        case MERCHANT_ERROR
        case INVALID_REQUEST_ERROR
        case RATE_LIMIT_ERROR
    }

    enum ErrorCode: String, Codable, Equatable {

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

    static var terminalStateError: IntegrationError {
        IntegrationError(
            category: .INVALID_REQUEST_ERROR,
            code: .INVALID_STATE_TRANSITION,
            detail: "The request provided was already in a terminal state.",
            field: nil
        )
    }
}

public struct UnexpectedError: Error, Codable, Equatable {
    let category: String
    let code: String
    let detail: String?
    let field: String?

    static var emptyErrorArray: UnexpectedError {
        return UnexpectedError(
            category: "API_ERROR",
            code: "EMPTY_ERROR_ARRAY",
            detail: "The API returned an error, but the `errors` array was empty. " +
                    "Please report this bug to Cash App Developer Support.",
            field: "errors"
        )
    }

    static func noRedirectURLFor(_ customerRequest: CustomerRequest) -> UnexpectedError {
        return UnexpectedError(
            category: "API_ERROR",
            code: "NO_REDIRECT_URL",
            detail: "The API returned a customer request without a `mobileURL` field to use for redirecting. " +
             "Customer request ID: \(customerRequest.id). Please report this bug to Cash App Developer Support.",
            field: "auth_flow_triggers.mobile_url"
        )
    }

    static func unknownErrorFor(_ error: Error) -> UnexpectedError {
        return UnexpectedError(
            category: "UNKNOWN_ERROR",
            code: "UNKNOWN_ERROR",
            detail: "Received an Error in an unexpected form: \(String(describing: error))",
            field: nil
        )
    }
}

public enum NetworkError: Error, Equatable {
    case noResponse
    case nilData(HTTPURLResponse)
    case invalidJSON(Data)
    case systemError(NSError)
}

// MARK: - Wrappers for serialization
struct APIErrorWrapper: Codable, Equatable {
    let errors: [APIError]
}

struct IntegrationErrorWrapper: Codable, Equatable {
    let errors: [IntegrationError]
}

struct UnexpectedErrorWrapper: Codable, Equatable {
    let errors: [UnexpectedError]
}
