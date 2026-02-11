//
//  LoggableTests.swift
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

class LoggableTests: XCTestCase {
    func test_loggable_type_object() {
        XCTAssert(LoggableType.string("test").object is String)
        XCTAssert(LoggableType.int(5).object is Int)
        XCTAssert(LoggableType.uint(7).object is UInt)
        XCTAssert(LoggableType.bool(false).object is Bool)
    }

    func test_loggable_type_description() {
        XCTAssertEqual(LoggableType.string("test").description, "test")
        XCTAssertEqual(LoggableType.int(5).description, "5")
        XCTAssertEqual(LoggableType.uint(7).description, "7")
        XCTAssertEqual(LoggableType.bool(false).description, "false")
    }

    func test_loggable_int() {
        XCTAssertEqual(5.loggableDescription, .int(5))
    }

    func test_loggable_bool() {
        XCTAssertEqual(true.loggableDescription, .bool(true))
    }

    func test_loggable_string() {
        XCTAssertEqual("test".loggableDescription, .string("test"))
    }

    func test_loggable_url() throws {
        let url = try XCTUnwrap("https://block.xyz/")
        XCTAssertEqual(url.loggableDescription, .string("https://block.xyz/"))
    }

    func test_loggable_date() throws {
        let date = try XCTUnwrap(
            DateComponents(
                calendar: Calendar(identifier: .gregorian),
                timeZone: .init(secondsFromGMT: 0),
                year: 2022,
                month: 4,
                day: 20,
                hour: 8,
                minute: 30,
                second: 45
            ).date
        )
        XCTAssertEqual(date.loggableDescription, .uint(1650443445000000))
    }

    func test_loggable_dictionary() {
        let loggable = ["Hello": "world", "Any": "value"].loggableDescription
        XCTAssertEqual(loggable, .string("{\"Any\":\"value\",\"Hello\":\"world\"}"))
    }

    func test_loggable_array() {
        let loggable = ["Hello", "world", "Any", "value"].loggableDescription
        XCTAssertEqual(loggable, .string("[\"Hello\",\"world\",\"Any\",\"value\"]"))
    }

    func test_loggable_money() {
        let loggable = Money(amount: 100, currency: .USD).loggableDescription
        XCTAssertEqual(loggable, .string("{\"amount\":100,\"currency\":\"USD\"}"))
    }

    func test_loggable_payment_action_one_time_payment() {
        let paymentAction = PaymentAction.oneTimePayment(
            scopeID: "test",
            money: Money(amount: 100, currency: .USD)
        )
        let loggable = LoggablePaymentAction(paymentAction: paymentAction).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string("{\"amount\":100,\"currency\":\"USD\",\"scope_id\":\"test\",\"type\":\"ONE_TIME_PAYMENT\"}"))
    }

    func test_loggable_payment_action_on_file_payment() {
        let paymentAction = PaymentAction.onFilePayment(
            scopeID: "test",
            accountReferenceID: "account4"
        )
        let loggable = LoggablePaymentAction(paymentAction: paymentAction).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string(#"{"account_reference_id":"FILTERED","scope_id":"test","type":"ON_FILE_PAYMENT"}"#))
    }

    func test_loggable_payment_action_on_file_payout() {
        let paymentAction = PaymentAction.onFilePayout(
            scopeID: "test",
            accountReferenceID: "account5"
        )
        let loggable = LoggablePaymentAction(paymentAction: paymentAction).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string(#"{"account_reference_id":"FILTERED","scope_id":"test","type":"ON_FILE_PAYOUT"}"#))
    }

    func test_loggable_grant() throws {
        let grant = try XCTUnwrap(TestValues.approvedRequestGrants.first)
        let loggable = LoggableGrant(grant: grant).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string("{\"action\":{\"account_reference_id\":\"FILTERED\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"type\":\"ON_FILE_PAYMENT\"},\"channel\":\"IN_APP\",\"created_at\":1666299823249000,\"customer_id\":\"CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc\",\"expires_at\":1823979823159000,\"id\":\"GRG_AZYyHv2DwQltw0SiCLTaRb73y40XFe2dWM690WDF9Btqn-uTCYAUROa4ciwCdDnZcG4PuY1m_i3gwHODiO8DSf9zdMmRl1T0SM267vzuldnBs246-duHZhcehhXtmhfU8g\",\"status\":\"ACTIVE\",\"type\":\"EXTENDED\",\"updated_at\":1666299823249000}"))
    }

    func test_loggable_grant_init() throws {
        let grant = try XCTUnwrap(TestValues.approvedRequestGrants.first)
        let loggableGrant = LoggableGrant(grant: grant)

        XCTAssertEqual(grant.id, loggableGrant.id)
        XCTAssertEqual(grant.customerID, loggableGrant.customerID)
        XCTAssertEqual(grant.status, loggableGrant.status)
        XCTAssertEqual(grant.type, loggableGrant.type)
        XCTAssertEqual(grant.channel, loggableGrant.channel)
        XCTAssertEqual(grant.createdAt, loggableGrant.createdAt)
        XCTAssertEqual(grant.updatedAt, loggableGrant.updatedAt)
        XCTAssertEqual(grant.expiresAt, loggableGrant.expiresAt)
    }

    func test_loggable_payment_action_init() {
        let paymentAction = PaymentAction(
            type: .ONE_TIME_PAYMENT,
            scopeID: "scopeID",
            money: Money(amount: 100, currency: .USD),
            accountReferenceID: "account",
            clearing: true
        )
        let loggablePaymentAction = LoggablePaymentAction(paymentAction: paymentAction)

        XCTAssertEqual(loggablePaymentAction.accountReferenceID, "FILTERED")
        XCTAssertEqual(paymentAction.scopeID, loggablePaymentAction.scopeID)
        XCTAssertEqual(paymentAction.clearing, loggablePaymentAction.clearing)
        XCTAssertEqual(paymentAction.money, loggablePaymentAction.money)
    }
}
