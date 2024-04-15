//
//  CustomerRequest+ObjCTests.swift
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

final class CustomerRequest_ObjCTests: XCTestCase {

    // MARK: - CAPCreateCustomerRequestParams

    func test_CAPCreateCustomerRequestParams_init_withCreateCustomerRequestParams() {
        let params = CreateCustomerRequestParams(
            actions: [oneTimePayment],
            redirectURL: redirectURL,
            referenceID: refrenceID,
            metadata: metadata
        )

        let capParams = CAPCreateCustomerRequestParams(createCustomerRequestParams: params)
        XCTAssertEqual(capParams.actions.map(\.paymentAction), [oneTimePayment])
        XCTAssertEqual(capParams.channel, "IN_APP")
        XCTAssertEqual(capParams.redirectURL, redirectURL)
        XCTAssertEqual(capParams.referenceID, refrenceID)
        XCTAssertEqual(capParams.metadata, metadata)
    }

    func test_CAPCreateCustomerRequestParams_initWithChannel() {
        let params = CAPCreateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            channel: .IN_PERSON,
            redirectURL: redirectURL,
            referenceID: refrenceID,
            metadata: metadata
        )

        XCTAssertEqual(params.actions.map(\.paymentAction), [oneTimePayment])
        XCTAssertEqual(params.channel, "IN_PERSON")
        XCTAssertEqual(params.redirectURL, redirectURL)
        XCTAssertEqual(params.referenceID, refrenceID)
        XCTAssertEqual(params.metadata, metadata)
    }

    func test_CAPCreateCustomerRequestParams_init() {
        let capParams = CAPCreateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            redirectURL: redirectURL,
            referenceID: refrenceID,
            metadata: metadata
        )

        XCTAssertEqual(capParams.actions.map(\.paymentAction), [oneTimePayment])
        XCTAssertEqual(capParams.channel, "IN_APP")
        XCTAssertEqual(capParams.redirectURL, redirectURL)
        XCTAssertEqual(capParams.referenceID, refrenceID)
        XCTAssertEqual(capParams.metadata, metadata)
    }

    func test_CAPCreateCustomerRequestParams_isEqual() {
        let capParams = CAPCreateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            redirectURL: redirectURL,
            referenceID: refrenceID,
            metadata: metadata
        )

        let otherParams = CAPCreateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            redirectURL: redirectURL,
            referenceID: refrenceID,
            metadata: metadata
        )

        XCTAssert(capParams.isEqual(otherParams))

        let nonEqual = CAPCreateCustomerRequestParams(
            actions: [],
            redirectURL: redirectURL,
            referenceID: nil,
            metadata: nil
        )
        XCTAssertFalse(capParams.isEqual(nonEqual))
    }

    // MARK: - CAPUpdateCustomerRequestParams

    func test_CAPUpdateCustomerRequestParams_init_withUpdateCustomerRequestParams() {
        let params = UpdateCustomerRequestParams(
            actions: [oneTimePayment],
            referenceID: refrenceID,
            metadata: metadata
        )

        let capParams = CAPUpdateCustomerRequestParams(updateCustomerRequestParams: params)
        XCTAssertEqual(capParams.actions.map(\.paymentAction), [clearingOneTimePayment])
        XCTAssertEqual(capParams.referenceID, refrenceID)
        XCTAssertEqual(capParams.metadata, metadata)
    }

    func test_CAPUpdateCustomerRequestParams_init() {
        let params = CAPUpdateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            referenceID: refrenceID,
            metadata: metadata
        )

        XCTAssertEqual(params.actions.map(\.paymentAction), [clearingOneTimePayment])
        XCTAssertEqual(params.referenceID, refrenceID)
        XCTAssertEqual(params.metadata, metadata)
    }

    func test_CAPUpdateCustomerRequestParams_isEqual() {
        let capParams = CAPUpdateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            referenceID: refrenceID,
            metadata: metadata
        )

        let otherParams = CAPUpdateCustomerRequestParams(
            actions: [CAPPaymentAction(paymentAction: oneTimePayment)],
            referenceID: refrenceID,
            metadata: metadata
        )

        XCTAssert(capParams.isEqual(otherParams))
        XCTAssertFalse(capParams.isEqual(CAPUpdateCustomerRequestParams(actions: [], referenceID: nil, metadata: nil)))
    }

    // MARK: - CAPCustomerRequest

    func test_CAPCustomerRequest_init_withCustomerRequest() {
        let capCustomerRequest = CAPCustomerRequest(customerRequest: customerRequest)
        XCTAssertEqual(customerRequest.id, capCustomerRequest.id)
        XCTAssertEqual(customerRequest.status.rawValue, capCustomerRequest.status)
        XCTAssertEqual(customerRequest.actions, capCustomerRequest.actions.map(\.paymentAction))
        XCTAssertEqual(customerRequest.authFlowTriggers, capCustomerRequest.authFlowTriggers?.authFlowTriggers)
        XCTAssertEqual(customerRequest.redirectURL, capCustomerRequest.redirectURL)
        XCTAssertEqual(customerRequest.channel.rawValue, capCustomerRequest.channel)
        XCTAssertEqual(customerRequest.origin, capCustomerRequest.origin?.origin)
        XCTAssertEqual(customerRequest.referenceID, capCustomerRequest.referenceID)
        XCTAssertEqual(customerRequest.requesterProfile, capCustomerRequest.requesterProfile?.requesterProfile)
        XCTAssertEqual(customerRequest.customerProfile, capCustomerRequest.customerProfile?.customerProfile)
        XCTAssertEqual(customerRequest.metadata, capCustomerRequest.metadata)
    }

    func test_CAPCustomerRequest_isEqual() {
        let customerRequest = CAPCustomerRequest(customerRequest: customerRequest)
        let otherCustomerRequest = CAPCustomerRequest(
            customerRequest: CustomerRequest(
                id: "GRR_123",
                status: .APPROVED,
                actions: [oneTimePayment],
                authFlowTriggers: authFlowTriggers,
                redirectURL: redirectURL,
                createdAt: fakeDate,
                updatedAt: fakeDate,
                expiresAt: fakeDate,
                origin: origin,
                channel: .IN_APP,
                grants: [grant],
                referenceID: refrenceID,
                requesterProfile: requesterProfile,
                customerProfile: customerProfile,
                metadata: metadata
            )
        )

        XCTAssert(customerRequest.isEqual(otherCustomerRequest))
    }

    // MARK: - PaymentAction

    func test_CAPPaymentAction_init_withPaymentAction() {
        let paymentAction = CAPPaymentAction(paymentAction: oneTimePayment)
        XCTAssertEqual(oneTimePayment.type.rawValue, paymentAction.type)
        XCTAssertEqual(oneTimePayment.scopeID, paymentAction.scopeID)
        XCTAssertEqual(oneTimePayment.money, paymentAction.money?.money)
        XCTAssertEqual(oneTimePayment.accountReferenceID, paymentAction.accountReferenceID)
    }

    func test_CAPPaymentAction_oneTimePayment() {
        let paymentAction = CAPPaymentAction.oneTimePayment(
            scopeID: scopeID,
            money: CAPMoney(amount: 100, currency: .USD)
        )
        XCTAssertEqual(paymentAction.type, "ONE_TIME_PAYMENT")
        XCTAssertEqual(paymentAction.scopeID, scopeID)
        XCTAssertEqual(paymentAction.money?.money, Money(amount: 100, currency: .USD))
        XCTAssertNil(paymentAction.accountReferenceID)
    }

    func test_CAPPaymentAction_onFilePayment() {
        let paymentAction = CAPPaymentAction.onFilePayment(scopeID: scopeID, accountReferenceID: "accountReferenceID")
        XCTAssertEqual(paymentAction.type, "ON_FILE_PAYMENT")
        XCTAssertEqual(paymentAction.scopeID, scopeID)
        XCTAssertEqual(paymentAction.accountReferenceID, "accountReferenceID")
        XCTAssertNil(paymentAction.money)
    }

    func test_CAPPaymentAction_isEqual() {
        let oneTimePayment = CAPPaymentAction.oneTimePayment(
            scopeID: scopeID,
            money: CAPMoney(amount: 100, currency: .USD)
        )
        let otherOneTimePayment = CAPPaymentAction.oneTimePayment(
            scopeID: scopeID,
            money: CAPMoney(amount: 100, currency: .USD)
        )
        let onFilePayment = CAPPaymentAction.onFilePayment(scopeID: scopeID, accountReferenceID: nil)
        XCTAssertFalse(oneTimePayment.isEqual(onFilePayment))
        XCTAssert(oneTimePayment.isEqual(otherOneTimePayment))
    }

    // MARK: - Money

    func test_CAPMoney_init_withMoney() {
        let oneDollar = Money(amount: 100, currency: .USD)
        let capMoney = CAPMoney(money: oneDollar)
        XCTAssertEqual(oneDollar.amount, capMoney.amount)
        XCTAssertEqual(oneDollar.currency, capMoney.currency.currency)
    }

    func test_CAPMoney_init() {
        let capMoney = CAPMoney(amount: 100, currency: .USD)
        XCTAssertEqual(capMoney.amount, 100)
        XCTAssertEqual(capMoney.currency, .USD)
    }

    func test_CAPMoney_isEqual() {
        let capMoney = CAPMoney(amount: 100, currency: .USD)
        let otherCapMoney = CAPMoney(amount: 100, currency: .USD)
        XCTAssert(capMoney.isEqual(otherCapMoney))
        XCTAssertFalse(capMoney.isEqual(CAPMoney(amount: 200, currency: .USD)))
    }

    // MARK: - Currency

    func test_currency() {
        XCTAssertEqual(CAPCurrency.USD.currency, Currency.USD)
        XCTAssertEqual(Currency.USD.capCurrency, .USD)
    }

    // MARK: - Channel

    func test_channel() {
        XCTAssertEqual(CAPChannel.IN_APP.channel, .IN_APP)
        XCTAssertEqual(CAPChannel.IN_PERSON.channel, .IN_PERSON)
        XCTAssertEqual(CAPChannel.ONLINE.channel, .ONLINE)
    }

    // MARK: - Private

    private let refrenceID = "refrenceID"
    private let metadata = ["Meta": "Data"]
    private var scopeID = "SCOPE_ID"
    private var redirectURL = URL(string: "paykitdemo://callback")!
    private let fakeDate = Date(timeIntervalSince1970: 1712793605)

    private var oneTimePayment: PaymentAction {
        .oneTimePayment(scopeID: scopeID, money: Money(amount: 100, currency: .USD))
    }

    private var clearingOneTimePayment: PaymentAction {
        var action = PaymentAction.oneTimePayment(scopeID: scopeID, money: Money(amount: 100, currency: .USD))
        action.clearing = true
        return action
    }

    private var requesterProfile: CustomerRequest.RequesterProfile {
        CustomerRequest.RequesterProfile(
            name: "Requester",
            logoURL: URL(string: "https://requester.com/logo")!
        )
    }

    private var customerProfile: CustomerRequest.CustomerProfile {
        CustomerRequest.CustomerProfile(
            id: "CUSTOMER_ID",
            cashtag: "$CASH_TAG"
        )
    }

    private var authFlowTriggers: CustomerRequest.AuthFlowTriggers {
        let url = URL(string: "https://qrcode.com/image")!

        return CustomerRequest.AuthFlowTriggers(
            qrCodeImageURL: url,
            qrCodeSVGURL: url,
            mobileURL: url,
            refreshesAt: fakeDate
        )
    }

    private var origin: CustomerRequest.Origin {
        CustomerRequest.Origin(type: .DIRECT, id: "origin_id")
    }

    private var grant: CustomerRequest.Grant {
        CustomerRequest.Grant(
            id: "GRANT_123",
            customerID: "customer_ID",
            action: oneTimePayment,
            status: .ACTIVE,
            type: .ONE_TIME,
            channel: .IN_APP,
            createdAt: fakeDate,
            updatedAt: fakeDate,
            expiresAt: fakeDate
        )
    }

    private var customerRequest: CustomerRequest {
        CustomerRequest(
            id: "GRR_123",
            status: .APPROVED,
            actions: [oneTimePayment],
            authFlowTriggers: authFlowTriggers,
            redirectURL: redirectURL,
            createdAt: fakeDate,
            updatedAt: fakeDate,
            expiresAt: fakeDate,
            origin: origin,
            channel: .IN_APP,
            grants: [grant],
            referenceID: refrenceID,
            requesterProfile: requesterProfile,
            customerProfile: customerProfile,
            metadata: metadata
        )
    }
}
