//
//  CashAppPayState+ObjCTests.swift
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

final class CashAppPayState_ObjCTests: XCTestCase {
    func test_notStarted() {
        let state = CashAppPayState.notStarted.asCAPCashAppPayState
        XCTAssert(state is CAPCashAppPayStateNotStarted)
    }

    func test_notStarted_isEqual() {
        let state = CAPCashAppPayStateNotStarted()
        XCTAssert(state.isEqual(CAPCashAppPayStateNotStarted()))
    }

    func test_creatingCustomerRequest() throws {
        let state = CashAppPayState
            .creatingCustomerRequest(TestValues.createCustomerRequestParams)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateCreatingCustomerRequest)
        XCTAssertEqual(
            unwrapped.params.createCustomerRequestParams,
            TestValues.createCustomerRequestParams
        )
    }

    func test_creatingCustomerRequest_isEqual() {
        let state = CAPCashAppPayStateCreatingCustomerRequest(
            params: .init(createCustomerRequestParams: TestValues.createCustomerRequestParams)
        )
        let otherState = CAPCashAppPayStateCreatingCustomerRequest(
            params: .init(createCustomerRequestParams: TestValues.createCustomerRequestParams)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_updatingCustomerRequest() throws {
        let state = CashAppPayState
            .updatingCustomerRequest(
                request: TestValues.customerRequest,
                params: TestValues.updateCustomerRequestParams
            )
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateUpdatingCustomerRequest)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
        XCTAssertEqual(
            unwrapped.params.updateCustomerRequestParams,
            TestValues.updateCustomerRequestParams
        )
    }

    func test_updatingCustomerRequest_isEqual() {
        let state = CAPCashAppPayStateUpdatingCustomerRequest(
            request: .init(customerRequest: TestValues.customerRequest),
            params: .init(updateCustomerRequestParams: TestValues.updateCustomerRequestParams)
        )
        let otherState = CAPCashAppPayStateUpdatingCustomerRequest(
            request: .init(customerRequest: TestValues.customerRequest),
            params: .init(updateCustomerRequestParams: TestValues.updateCustomerRequestParams)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_readyToAuthorize() throws {
        let state = CashAppPayState
            .readyToAuthorize(TestValues.customerRequest)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateReadyToAuthorize)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
    }

    func test_readyToAuthorize_isEqual() {
        let state = CAPCashAppPayStateReadyToAuthorize(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        let otherState = CAPCashAppPayStateReadyToAuthorize(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_redirecting() throws {
        let state = CashAppPayState
            .redirecting(TestValues.customerRequest)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateRedirecting)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
    }

    func test_redirecting_isEqual() throws {
        let state = CAPCashAppPayStateRedirecting(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        let otherState = CAPCashAppPayStateRedirecting(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_polling() throws {
        let state = CashAppPayState
            .polling(TestValues.customerRequest)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStatePolling)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
    }

    func test_polling_isEqual() throws {
        let state = CAPCashAppPayStatePolling(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        let otherState = CAPCashAppPayStatePolling(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_declined() throws {
        let state = CashAppPayState
            .declined(TestValues.customerRequest)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateDeclined)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
    }

    func test_declined_isEqual() throws {
        let state = CAPCashAppPayStateDeclined(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        let otherState = CAPCashAppPayStateDeclined(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_approved() throws {
        let state = CashAppPayState
            .approved(request: TestValues.customerRequest, grants: TestValues.approvedRequestGrants)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateApproved)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
        XCTAssertEqual(
            unwrapped.grants.map(\.grant),
            TestValues.approvedRequestGrants
        )
    }

    func test_approved_isEqual() throws {
        let state = CAPCashAppPayStateApproved(
            request: .init(customerRequest: TestValues.customerRequest),
            grants: TestValues.approvedRequestGrants.map(CAPCustomerRequestGrant.init(grant:))
        )
        let otherState = CAPCashAppPayStateApproved(
            request: .init(customerRequest: TestValues.customerRequest),
            grants: TestValues.approvedRequestGrants.map(CAPCustomerRequestGrant.init(grant:))
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_refreshing() throws {
        let state = CashAppPayState
            .refreshing(TestValues.customerRequest)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateRefreshing)
        XCTAssertEqual(
            unwrapped.request.customerRequest,
            TestValues.customerRequest
        )
    }

    func test_refreshing_isEqual() throws {
        let state = CAPCashAppPayStateRefreshing(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        let otherState = CAPCashAppPayStateRefreshing(
            request: .init(customerRequest: TestValues.customerRequest)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_apiError() throws {
        let state = CashAppPayState
            .apiError(TestValues.internalServerError)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateAPIError)
        XCTAssertEqual(
            unwrapped.apiError,
            TestValues.internalServerError
        )
    }

    func test_apiError_isEqual() throws {
        let state = CAPCashAppPayStateAPIError(
            apiError: TestValues.internalServerError
        )
        let otherState = CAPCashAppPayStateAPIError(
            apiError: TestValues.internalServerError
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_integrationError() throws {
        let state = CashAppPayState
            .integrationError(TestValues.brandNotFoundError)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateIntegrationError)
        XCTAssertEqual(
            unwrapped.integrationError,
            TestValues.brandNotFoundError
        )
    }

    func test_integrationError_isEqual() throws {
        let state = CAPCashAppPayStateIntegrationError(
            integrationError: TestValues.unauthorizedError
        )
        let otherState = CAPCashAppPayStateIntegrationError(
            integrationError: TestValues.unauthorizedError
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_networkError_noResponse() throws {
        let state = CashAppPayState
            .networkError(TestValues.noResponseError)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateNetworkError)
        XCTAssert(unwrapped.networkError is CAPNetworkErrorNoResponse)
    }

    func test_networkError_nilData() throws {
        let state = CashAppPayState
            .networkError(TestValues.nilDataError)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateNetworkError)
        XCTAssert(unwrapped.networkError is CAPNetworkErrorNilData)
    }

    func test_networkError_invalidJSON() throws {
        let state = CashAppPayState
            .networkError(TestValues.invalidJSONError)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateNetworkError)
        XCTAssert(unwrapped.networkError is CAPNetworkErrorInvalidJSON)
    }

    func test_networkError_systemError() throws {
        let error = NSError()
        let state = CashAppPayState
            .networkError(TestValues.systemError(underlyingError: error))
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateNetworkError)
        XCTAssert(unwrapped.networkError === error)
    }

    func test_networkError_isEqual() throws {
        let state = CAPCashAppPayStateNetworkError(
            networkError: NSError(domain: "domain", code: 1)
        )
        let otherState = CAPCashAppPayStateNetworkError(
            networkError: NSError(domain: "domain", code: 1)
        )
        XCTAssert(state.isEqual(otherState))
    }

    func test_unexpectedError() throws {
        let state = CashAppPayState
            .unexpectedError(.emptyErrorArray)
            .asCAPCashAppPayState
        let unwrapped = try XCTUnwrap(state as? CAPCashAppPayStateUnexpectedError)
        XCTAssertEqual(unwrapped.unexpectedError, .emptyErrorArray)
    }

    func test_unexpectedError_isEqual() throws {
        let state = CAPCashAppPayStateUnexpectedError(
            unexpectedError: .emptyErrorArray
        )
        let otherState = CAPCashAppPayStateUnexpectedError(
            unexpectedError: .emptyErrorArray
        )
        XCTAssert(state.isEqual(otherState))
    }
}
