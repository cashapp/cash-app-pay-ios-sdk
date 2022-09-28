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

    func test_loggable_payment_action() {
        let loggable = PaymentAction.oneTimePayment(
            scopeID: "test",
            money: Money(amount: 100, currency: .USD)
        ).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string("{\"amount\":100,\"currency\":\"USD\",\"type\":\"ONE_TIME_PAYMENT\",\"scope_id\":\"test\"}"))
    }

    func test_loggable_grant() throws {
        let loggable = try XCTUnwrap(TestValues.approvedRequestGrants.first).loggableDescription
        // swiftlint:disable:next line_length
        XCTAssertEqual(loggable, .string("{\"status\":\"ACTIVE\",\"channel\":\"IN_APP\",\"action\":{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"account4\"},\"id\":\"GRG_AZYyHv2DwQltw0SiCLTaRb73y40XFe2dWM690WDF9Btqn-uTCYAUROa4ciwCdDnZcG4PuY1m_i3gwHODiO8DSf9zdMmRl1T0SM267vzuldnBs246-duHZhcehhXtmhfU8g\",\"created_at\":1666299823249000,\"expires_at\":1823979823159000,\"type\":\"EXTENDED\",\"customer_id\":\"CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc\",\"updated_at\":1666299823249000}"))
    }
}
