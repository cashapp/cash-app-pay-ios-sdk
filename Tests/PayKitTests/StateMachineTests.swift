//
//  StateMachineTests.swift
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

class StateMachineTests: XCTestCase {

    // MARK: - State Changes + Network Calls
    func test_state_creatingCustomerRequest() throws {
        let mockNetworkManager = MockNetworkManager()
        let stateMachine = StateMachine(networkManager: mockNetworkManager, analyticsService: MockAnalytics())
        stateMachine.state = .creatingCustomerRequest(TestValues.createCustomerRequestParams)
        XCTAssertEqual(mockNetworkManager.createCustomerRequestCount, 1)
    }

    func test_state_updatingCustomerRequest() throws {
        let mockNetworkManager = MockNetworkManager()
        let stateMachine = StateMachine(networkManager: mockNetworkManager, analyticsService: MockAnalytics())
        stateMachine.state = .updatingCustomerRequest(
            request: TestValues.customerRequest,
            params: TestValues.updateCustomerRequestParams
        )
        XCTAssertEqual(mockNetworkManager.updateCustomerRequestCount, 1)
    }

    func test_state_polling() throws {
        let mockNetworkManager = MockNetworkManager()
        let stateMachine = StateMachine(networkManager: mockNetworkManager, analyticsService: MockAnalytics())
        stateMachine.state = .polling(TestValues.customerRequest)
        XCTAssertEqual(mockNetworkManager.retrieveCustomerRequestCount, 1)
    }

    // MARK: - Setting State for Errors
    func test_setStateForError() throws {
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: MockAnalytics())

        XCTAssertEqual(stateMachine.state, .notStarted)

        let apiError = APIError(category: .API_ERROR, code: .INTERNAL_SERVER_ERROR, detail: nil, field: nil)
        stateMachine.setErrorState(apiError)
        XCTAssertEqual(stateMachine.state, .apiError(apiError))

        let integrationError = IntegrationError(
            category: .AUTHENTICATION_ERROR,
            code: .UNAUTHORIZED,
            detail: nil,
            field: nil
        )
        stateMachine.setErrorState(integrationError)
        XCTAssertEqual(stateMachine.state, .integrationError(integrationError))

        let networkError = NetworkError.noResponse
        stateMachine.setErrorState(networkError)
        XCTAssertEqual(stateMachine.state, .networkError(networkError))

        let unexpectedError = UnexpectedError.emptyErrorArray
        stateMachine.setErrorState(unexpectedError)
        XCTAssertEqual(stateMachine.state, .unexpectedError(unexpectedError))
    }

    // MARK: - Redirect Notification Handling
    func test_handleRedirectNotification() throws {
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: MockAnalytics())
        let customerRequest = TestValues.customerRequest

        // The state machine should advance to .polling if we're in .redirecting.
        stateMachine.state = .redirecting(customerRequest)
        NotificationCenter.default.post(name: CashAppPay.RedirectNotification, object: nil)
        XCTAssertEqual(stateMachine.state, .polling(customerRequest))

        // The state machine should also advance to .polling if we're in .readyToAuthorize;
        // it's unexpected, but we can continue.
        stateMachine.state = .readyToAuthorize(customerRequest)
        NotificationCenter.default.post(name: CashAppPay.RedirectNotification, object: nil)
        XCTAssertEqual(stateMachine.state, .polling(customerRequest))

        // If we're in any other state, we shouldn't advance.
        stateMachine.state = .notStarted
        NotificationCenter.default.post(name: CashAppPay.RedirectNotification, object: nil)
        XCTAssertEqual(stateMachine.state, .notStarted)

        stateMachine.state = .creatingCustomerRequest(TestValues.createCustomerRequestParams)
        NotificationCenter.default.post(name: CashAppPay.RedirectNotification, object: nil)
        XCTAssertEqual(stateMachine.state, .creatingCustomerRequest(TestValues.createCustomerRequestParams))
    }

    // MARK: - Polling Timer
    func test_polling_timer() throws {
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: MockAnalytics())
        stateMachine.state = .redirecting(TestValues.customerRequest)
        XCTAssertNil(stateMachine.pollingTimer)

        stateMachine.state = .polling(TestValues.customerRequest)
        XCTAssertNotNil(stateMachine.pollingTimer)

        stateMachine.state = .declined(TestValues.customerRequest)
        XCTAssertNil(stateMachine.pollingTimer)
    }

    // MARK: - Foreground Handling
    func test_foregroundHandling() throws {
        let stateMachine = StateMachine(networkManager: MockNetworkManager(), analyticsService: MockAnalytics())

        stateMachine.state = .readyToAuthorize(TestValues.customerRequest)
        XCTAssertNil(stateMachine.notificationObserver)

        // If we're in .redirecting, we should be handling foreground notifications.
        stateMachine.state = .redirecting(TestValues.customerRequest)
        XCTAssertNotNil(stateMachine.notificationObserver)

        stateMachine.state = .polling(TestValues.customerRequest)
        XCTAssertNil(stateMachine.notificationObserver)

        stateMachine.state = .declined(TestValues.customerRequest)
        XCTAssertNil(stateMachine.notificationObserver)
    }
}

class MockAnalytics: AnalyticsService {
    var trackStub: ((AnalyticsEvent) throws -> Void)

    init(trackStub: @escaping (AnalyticsEvent) throws -> Void = { _ in }) {
        self.trackStub = trackStub
    }

    func track(_ event: AnalyticsEvent) {
        do {
            try trackStub(event)
        } catch {
            XCTFail("Unexpectedly threw an error")
        }
    }
}

class MockNetworkManager: NetworkManager {
    convenience init() {
        self.init(clientID: "test_client", endpoint: .sandbox)
    }

    var createCustomerRequestCount: Int = 0
    var updateCustomerRequestCount: Int = 0
    var retrieveCustomerRequestCount: Int = 0

    override func createCustomerRequest(
        params: CreateCustomerRequestParams,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        createCustomerRequestCount += 1
    }

    override func updateCustomerRequest(
        _ request: CustomerRequest,
        with params: UpdateCustomerRequestParams,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        updateCustomerRequestCount += 1
    }

    override func retrieveCustomerRequest(
        _ request: CustomerRequest,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        retrieveCustomerRequestCount += 1
    }
}
