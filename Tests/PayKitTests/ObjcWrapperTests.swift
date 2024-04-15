//
//  ObjCWrapperTests.swift
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

final class ObjCWrapperTests: XCTestCase {

    private var testClientID: String!

    override func setUp() {
        super.setUp()
        testClientID = "client_id"
    }

    override func tearDown() {
        testClientID = nil
        super.tearDown()
    }

    func test_redirectNotification() {
        XCTAssertEqual(ObjCWrapper.RedirectNotification, CashAppPay.RedirectNotification)
    }

    func testEndpoint_defaultsToProduction() {
        let cap = ObjCWrapper(clientID: testClientID)
        XCTAssertEqual(cap.endpoint, .production)
    }

    func testEndpoint() {
        let cap = ObjCWrapper(clientID: testClientID, endpoint: .sandbox)
        XCTAssertEqual(cap.endpoint, .sandbox)
    }

    func test_retrieveCustomerRequest() {
        let expectation = self.expectation(description: "retrieve customer request")
        let mockCashAppPay = MockCashAppPay(retrieveCustomerRequestHandler: { [weak self] id, _ in
            self?.XCTAssertEqual(id, "GRR_id")
            expectation.fulfill()
        })
        let objcWrapper = ObjCWrapper(cashAppPay: mockCashAppPay)
        objcWrapper.retrieveCustomerRequest(id: "GRR_id") { _, _ in }
        waitForExpectations(timeout: 0.2)
    }

    func test_createCustomerRequest() {
        let expectation = self.expectation(description: "create customer request")
        let mockCashAppPay = MockCashAppPay(createCustomerRequestHandler: { _ in
            expectation.fulfill()
        })
        let objcWrapper = ObjCWrapper(cashAppPay: mockCashAppPay)
        let objcParams = CAPCreateCustomerRequestParams(
            createCustomerRequestParams: TestValues.createCustomerRequestParams
        )
        objcWrapper.createCustomerRequest(params: objcParams)
        waitForExpectations(timeout: 0.2)
    }

    func test_updateCustomerRequest() {
        let expectation = self.expectation(description: "update customer request")
        let mockCashAppPay = MockCashAppPay(updateCustomerRequestHandler: { _, _ in
            expectation.fulfill()
        })
        let objcWrapper = ObjCWrapper(cashAppPay: mockCashAppPay)
        let objcCustomerRequest = CAPCustomerRequest(customerRequest: TestValues.customerRequest)
        let objcParams = CAPUpdateCustomerRequestParams(
            updateCustomerRequestParams: TestValues.updateCustomerRequestParams
        )
        objcWrapper.updateCustomerRequest(objcCustomerRequest, with: objcParams)
        waitForExpectations(timeout: 0.2)
    }

    func test_authorizeCustomerRequest() {
        let expectation = self.expectation(description: "authorize customer request")
        let mockCashAppPay = MockCashAppPay(authorizeCustomerRequestHandler: { _, _ in
            expectation.fulfill()
        })
        let objcWrapper = ObjCWrapper(cashAppPay: mockCashAppPay)
        let objcCustomerRequest = CAPCustomerRequest(customerRequest: TestValues.customerRequest)
        objcWrapper.authorizeCustomerRequest(objcCustomerRequest)
        waitForExpectations(timeout: 0.2)
    }

    func test_notifyObserversOnStateChange() {
        let expectation = self.expectation(description: "State did change observed")
        expectation.expectedFulfillmentCount = 2

        let firstObserver = MockObserver { state in
            XCTAssert(state is CAPCashAppPayStateApproved)
            expectation.fulfill()
        }

        let secondObserver = MockObserver { state in
            XCTAssert(state is CAPCashAppPayStateApproved)
            expectation.fulfill()
        }

        let objcWrapper = ObjCWrapper(cashAppPay: MockCashAppPay())
        objcWrapper.addObserver(firstObserver)
        objcWrapper.addObserver(secondObserver)
        objcWrapper.stateDidChange(to: .approved(request: TestValues.customerRequest, grants: []))

        waitForExpectations(timeout: 0.3)
    }

    // MARK: - Private

    private final class MockObserver: NSObject, CAPCashAppPayObserver {

        private let stateDidChangeHandler: (CAPCashAppPayState) -> Void

        init(stateDidChangeHandler: @escaping (CAPCashAppPayState) -> Void) {
            self.stateDidChangeHandler = stateDidChangeHandler
        }

        func stateDidChange(to state: CAPCashAppPayState) {
            stateDidChangeHandler(state)
        }
    }

    private final class MockCashAppPay: CashAppPay {

        let retrieveCustomerRequestHandler: ((String, (Result<CustomerRequest, Error>) -> Void) -> Void)?
        let createCustomerRequestHandler: ((CreateCustomerRequestParams) -> Void)?
        let updateCustomerRequestHandler: ((CustomerRequest, UpdateCustomerRequestParams) -> Void)?
        let authorizeCustomerRequestHandler: ((CustomerRequest, AuthorizationMethod) -> Void)?

        init(
            retrieveCustomerRequestHandler: ((String, (Result<CustomerRequest, Error>) -> Void) -> Void)? = nil,
            createCustomerRequestHandler: ((CreateCustomerRequestParams) -> Void)? = nil,
            updateCustomerRequestHandler: ((CustomerRequest, UpdateCustomerRequestParams) -> Void)? = nil,
            authorizeCustomerRequestHandler: ((CustomerRequest, AuthorizationMethod) -> Void)? = nil
        ) {
            self.retrieveCustomerRequestHandler = retrieveCustomerRequestHandler
            self.createCustomerRequestHandler = createCustomerRequestHandler
            self.updateCustomerRequestHandler = updateCustomerRequestHandler
            self.authorizeCustomerRequestHandler = authorizeCustomerRequestHandler
            let networkManager = MockNetworkManager()
            let stateMachine = StateMachine(networkManager: networkManager, analyticsService: MockAnalytics())
            super.init(stateMachine: stateMachine, networkManager: networkManager, endpoint: .sandbox)
        }

        override func retrieveCustomerRequest(
            id: String,
            completion: @escaping (Result<CustomerRequest, Error>) -> Void
        ) {
            retrieveCustomerRequestHandler?(id, completion)
        }

        override func createCustomerRequest(params: CreateCustomerRequestParams) {
            createCustomerRequestHandler?(params)
        }

        override func updateCustomerRequest(_ request: CustomerRequest, with params: UpdateCustomerRequestParams) {
            updateCustomerRequestHandler?(request, params)
        }

        override func authorizeCustomerRequest(_ request: CustomerRequest, method: AuthorizationMethod = .DEEPLINK) {
            authorizeCustomerRequestHandler?(request, method)
        }
    }
}
