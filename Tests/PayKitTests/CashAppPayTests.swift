//
//  PayKitTests.swift
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

class PayKitTests: XCTestCase {

    private var payKit: CashAppPay!

    override func setUp() {
        super.setUp()
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: MockAnalytics())
        self.payKit = CashAppPay(stateMachine: stateMachine, endpoint: .production)
    }

    override func tearDown() {
        self.payKit = nil
        super.tearDown()
    }

    func test_updating_approved_customer_request_triggers_error() throws {
        let stateExpectation = expectation(description: "Integration Error")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .redirecting,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .updatingCustomerRequest:
                XCTFail("Do not update authorized Request")
            case .integrationError(let integrationError):
                self.XCTAssertEqual(integrationError.category, .INVALID_REQUEST_ERROR)
                self.XCTAssertEqual(integrationError.code, .INVALID_STATE_TRANSITION)
                self.XCTAssertEqual(integrationError.detail, "The request provided was already in a terminal state.")
                XCTAssertNil(integrationError.field)
                stateExpectation.fulfill()
            }
        }
        payKit.addObserver(observer)
        payKit.updateCustomerRequest(
            TestValues.fullyPopulatedApprovedRequest,
            with: TestValues.updateCustomerRequestParams
        )
        waitForExpectations(timeout: 0.5)
    }

    func test_updating_declined_customer_request_triggers_error() throws {
        let stateExpectation = expectation(description: "Integration Error")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .redirecting,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .updatingCustomerRequest:
                XCTFail("Do not update authorized Request")
            case .integrationError(let integrationError):
                self.XCTAssertEqual(integrationError.category, .INVALID_REQUEST_ERROR)
                self.XCTAssertEqual(integrationError.code, .INVALID_STATE_TRANSITION)
                self.XCTAssertEqual(integrationError.detail, "The request provided was already in a terminal state.")
                XCTAssertNil(integrationError.field)
                stateExpectation.fulfill()
            }
        }
        payKit.addObserver(observer)
        payKit.updateCustomerRequest(
            TestValues.fullyPopulatedDeclinedRequest,
            with: TestValues.updateCustomerRequestParams
        )
        waitForExpectations(timeout: 0.5)
    }

    func test_updating_pending_customer_request_triggers_updating() throws {
        let stateExpectation = expectation(description: "Updating")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .redirecting,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .updatingCustomerRequest:
                stateExpectation.fulfill()
            case .integrationError:
                XCTFail("Do not update authorized Request")
            }
        }
        payKit.addObserver(observer)
        payKit.updateCustomerRequest(
            TestValues.fullyPopulatedPendingRequest,
            with: TestValues.updateCustomerRequestParams
        )
        waitForExpectations(timeout: 0.5)
    }

    func test_updating_processing_customer_request_triggers_updating() throws {
        let stateExpectation = expectation(description: "Updating")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .redirecting,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .updatingCustomerRequest:
                stateExpectation.fulfill()
            case .integrationError:
                XCTFail("Do not update authorized Request")
            }
        }
        payKit.addObserver(observer)
        payKit.updateCustomerRequest(
            TestValues.fullyPopulatedProcessingRequest,
            with: TestValues.updateCustomerRequestParams
        )
        waitForExpectations(timeout: 0.5)
    }

    func test_authorizing_declined_customer_request_triggers_error() throws {
        let stateExpectation = expectation(description: "Integration Error")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .updatingCustomerRequest,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .redirecting:
                XCTFail("Do not redirect authorized Request")
            case .integrationError(let integrationError):
                self.XCTAssertEqual(integrationError.category, .INVALID_REQUEST_ERROR)
                self.XCTAssertEqual(integrationError.code, .INVALID_STATE_TRANSITION)
                self.XCTAssertEqual(integrationError.detail, "The request provided was already in a terminal state.")
                XCTAssertNil(integrationError.field)
                stateExpectation.fulfill()
            }
        }
        payKit.addObserver(observer)
        payKit.authorizeCustomerRequest(TestValues.fullyPopulatedDeclinedRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_authorizing_pending_customer_request_triggers_redirecting() throws {
        let stateExpectation = expectation(description: "Redirecting")
        let observer = TestObserver { state in
            switch state {
            case .notStarted, .creatingCustomerRequest, .updatingCustomerRequest,
                    .readyToAuthorize, .polling, .declined, .approved, .apiError, .networkError, .unexpectedError:
                break
            case .redirecting:
                stateExpectation.fulfill()
            case .integrationError:
                XCTFail("Do not redirect authorized Request")
            }
        }
        payKit.addObserver(observer)
        payKit.authorizeCustomerRequest(TestValues.fullyPopulatedPendingRequest)
        waitForExpectations(timeout: 0.5)
    }
}

private class TestObserver: CashAppPayObserver {
    var stateDidChangeStub: (CashAppPayState) -> Void

    init(stateDidChangeStub: @escaping (CashAppPayState) -> Void) {
        self.stateDidChangeStub = stateDidChangeStub
    }

    func stateDidChange(to state: CashAppPayState) {
        stateDidChangeStub(state)
    }
}
