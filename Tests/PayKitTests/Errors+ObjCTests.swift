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

@testable import PayKit
import XCTest

final class Errors_ObjCTests: XCTestCase {

    // MARK: - APIError

    func test_apiError() {
        let objcError = CAPApiError(apiError: TestValues.internalServerError)
        XCTAssertEqual(objcError.category, TestValues.internalServerError.category.capApiErrorCategory)
        XCTAssertEqual(objcError.code, TestValues.internalServerError.code.capApiErrorCode.rawValue)
        XCTAssertEqual(objcError.detail, TestValues.internalServerError.detail)
        XCTAssertEqual(objcError.field, TestValues.internalServerError.field)
    }

    func test_apiError_category() {
        XCTAssertEqual(APIError.Category.API_ERROR.capApiErrorCategory, .API_ERROR)
    }

    func test_apiError_code() {
        XCTAssertEqual(APIError.ErrorCode.INTERNAL_SERVER_ERROR.capApiErrorCode, .INTERNAL_SERVER_ERROR)
        XCTAssertEqual(APIError.ErrorCode.SERVICE_UNAVAILABLE.capApiErrorCode, .SERVICE_UNAVAILABLE)
        XCTAssertEqual(APIError.ErrorCode.GATEWAY_TIMEOUT.capApiErrorCode, .GATEWAY_TIMEOUT)
    }

    // MARK: - IntegrationError

    func test_integrationError() {
        let objcError = CAPIntegrationError(integrationError: TestValues.brandNotFoundError)
        XCTAssertEqual(objcError.category, TestValues.brandNotFoundError.category.capIntegrationErrorCategory)
        XCTAssertEqual(objcError.code, TestValues.brandNotFoundError.code.capIntegrationErrorCode.rawValue)
        XCTAssertEqual(objcError.detail, TestValues.brandNotFoundError.detail)
        XCTAssertEqual(objcError.field, TestValues.brandNotFoundError.field)
    }

    func test_integrationError_category() {
        XCTAssertEqual(
            IntegrationError.Category.AUTHENTICATION_ERROR.capIntegrationErrorCategory,
                .AUTHENTICATION_ERROR
        )
        XCTAssertEqual(IntegrationError.Category.BRAND_ERROR.capIntegrationErrorCategory, .BRAND_ERROR)
        XCTAssertEqual(IntegrationError.Category.MERCHANT_ERROR.capIntegrationErrorCategory, .MERCHANT_ERROR)
        XCTAssertEqual(
            IntegrationError.Category.INVALID_REQUEST_ERROR.capIntegrationErrorCategory,
                .INVALID_REQUEST_ERROR
        )
        XCTAssertEqual(IntegrationError.Category.RATE_LIMIT_ERROR.capIntegrationErrorCategory, .RATE_LIMIT_ERROR)
    }

    func test_integrationError_code() {
        XCTAssertEqual(IntegrationError.ErrorCode.UNAUTHORIZED.capIntegrationErrorCode, .UNAUTHORIZED)
        XCTAssertEqual(IntegrationError.ErrorCode.CLIENT_DISABLED.capIntegrationErrorCode, .CLIENT_DISABLED)
        XCTAssertEqual(IntegrationError.ErrorCode.FORBIDDEN.capIntegrationErrorCode, .FORBIDDEN)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_TOO_LONG.capIntegrationErrorCode, .VALUE_TOO_LONG)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_TOO_SHORT.capIntegrationErrorCode, .VALUE_TOO_SHORT)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_EMPTY.capIntegrationErrorCode, .VALUE_EMPTY)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_REGEX_MISMATCH.capIntegrationErrorCode, .VALUE_REGEX_MISMATCH)
        XCTAssertEqual(IntegrationError.ErrorCode.INVALID_URL.capIntegrationErrorCode, .INVALID_URL)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_TOO_HIGH.capIntegrationErrorCode, .VALUE_TOO_HIGH)
        XCTAssertEqual(IntegrationError.ErrorCode.VALUE_TOO_LOW.capIntegrationErrorCode, .VALUE_TOO_LOW)
        XCTAssertEqual(IntegrationError.ErrorCode.ARRAY_LENGTH_TOO_LONG.capIntegrationErrorCode, .ARRAY_LENGTH_TOO_LONG)
        XCTAssertEqual(
            IntegrationError.ErrorCode.ARRAY_LENGTH_TOO_SHORT.capIntegrationErrorCode,
                .ARRAY_LENGTH_TOO_SHORT
        )
        XCTAssertEqual(IntegrationError.ErrorCode.INVALID_ARRAY_TYPE.capIntegrationErrorCode, .INVALID_ARRAY_TYPE)
        XCTAssertEqual(IntegrationError.ErrorCode.NOT_FOUND.capIntegrationErrorCode, .NOT_FOUND)
        XCTAssertEqual(IntegrationError.ErrorCode.CONFLICT.capIntegrationErrorCode, .CONFLICT)
        XCTAssertEqual(
            IntegrationError.ErrorCode.INVALID_STATE_TRANSITION.capIntegrationErrorCode,
                .INVALID_STATE_TRANSITION
        )
        XCTAssertEqual(IntegrationError.ErrorCode.CLIENT_NOT_FOUND.capIntegrationErrorCode, .CLIENT_NOT_FOUND)
        XCTAssertEqual(IntegrationError.ErrorCode.RATE_LIMITED.capIntegrationErrorCode, .RATE_LIMITED)
        XCTAssertEqual(IntegrationError.ErrorCode.BRAND_NOT_FOUND.capIntegrationErrorCode, .BRAND_NOT_FOUND)
        XCTAssertEqual(
            IntegrationError.ErrorCode.MERCHANT_MISSING_ADDRESS_OR_SITE.capIntegrationErrorCode,
                .MERCHANT_MISSING_ADDRESS_OR_SITE
        )
    }

    // MARK: - UnexpectedError

    func test_unexpectedError() {
        let objcError = CAPUnexpectedError(unexpectedError: TestValues.idempotencyKeyReusedError)
        XCTAssertEqual(objcError.category, TestValues.idempotencyKeyReusedError.category)
        XCTAssertEqual(objcError.codeMessage, TestValues.idempotencyKeyReusedError.code)
        XCTAssertEqual(objcError.detail, TestValues.idempotencyKeyReusedError.detail)
        XCTAssertEqual(objcError.field, TestValues.idempotencyKeyReusedError.field)
    }
}
