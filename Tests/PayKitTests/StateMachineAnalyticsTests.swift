//
//  StateMachineAnalyticsTests.swift
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

class StateMachineAnalyticsTests: XCTestCase {
    func test_initialization() {
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            XCTAssert(event is InitializationEvent)
            exp.fulfill()
        }
        _ = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)
        waitForExpectations(timeout: 0.5)
    }

    func test_observer() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        exp.expectedFulfillmentCount = 2
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                XCTAssertNotNil(event as? ListenerEvent)
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)
        stateMachine.addObserver(TestObserver())
        stateMachine.removeObserver(TestObserver())
        waitForExpectations(timeout: 0.5)
    }

    func test_create_request() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "create")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .creatingCustomerRequest(TestValues.createCustomerRequestParams)
        waitForExpectations(timeout: 0.5)
    }

    func test_update_request() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "update")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .updatingCustomerRequest(
            request: TestValues.customerRequest,
            params: TestValues.updateCustomerRequestParams
        )
        waitForExpectations(timeout: 0.5)
    }

    func test_ready_to_authorize() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "ready_to_authorize")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .readyToAuthorize(TestValues.customerRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_redirecting() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "redirect")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .redirecting(TestValues.customerRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_polling() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "polling")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .polling(TestValues.customerRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_declined() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "declined")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .declined(TestValues.customerRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_approved() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "approved")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .approved(request: TestValues.customerRequest, grants: TestValues.approvedRequestGrants)
        waitForExpectations(timeout: 0.5)
    }

    func test_refresh() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "refreshing")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .refreshing(TestValues.customerRequest)
        waitForExpectations(timeout: 0.5)
    }

    func test_api_error() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "api_error")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .apiError(TestValues.internalServerError)
        waitForExpectations(timeout: 0.5)
    }

    func test_integration_error() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "integration_error")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .integrationError(TestValues.brandNotFoundError)
        waitForExpectations(timeout: 0.5)
    }

    func test_networking_error() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "network_error")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .networkError(.noResponse)
        waitForExpectations(timeout: 0.5)
    }

    func test_unexpected_error() {
        let initializationExp = expectation(description: "Initialization Tracked")
        let exp = expectation(description: "Analytics Tracked")
        let analytics = MockAnalytics { event in
            if event is InitializationEvent {
                initializationExp.fulfill()
            } else {
                let event = try XCTUnwrap(event as? CustomerRequestEvent)
                self.XCTAssertEqual(event.action, "unexpected_error")
                exp.fulfill()
            }
        }
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: analytics)

        stateMachine.state = .unexpectedError(TestValues.idempotencyKeyReusedError)
        waitForExpectations(timeout: 0.5)
    }
}

private class TestObserver: CashAppPayObserver {
    func stateDidChange(to state: CashAppPayState) {}
}
