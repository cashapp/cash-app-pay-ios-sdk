//
//  CashAppPayButtonLabelTests.swift
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

import PayKit
import PayKitUI
import XCTest

class CashAppPayButtonLabelTests: XCTestCase {
    private let oneTime = PaymentAction.oneTimePayment(scopeID: "BRAND_1", money: nil)
    private let onFile = PaymentAction.onFilePayment(scopeID: "BRAND_1", accountReferenceID: nil)
    private let payout = PaymentAction.onFilePayout(scopeID: "BRAND_1", accountReferenceID: nil)
    private let profile = PaymentAction.customerProfileSharing(scopeID: "BRAND_1")

    func test_payments_use_pay() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime]), .pay)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [onFile]), .pay)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime, onFile]), .pay)
    }

    func test_payouts_use_cash_out() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [payout]), .cashOut)
    }

    func test_profile_sharing_mixed_actions_and_no_actions_use_continue() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [profile]), .continue)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [onFile, payout]), .continue)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime, profile]), .continue)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [payout, profile]), .continue)
        XCTAssertEqual(CashAppPayButtonLabel(actions: []), .continue)
    }

    func test_buy_and_checkout_are_only_set_explicitly() {
        let requests: [[PaymentAction]] = [
            [], [oneTime], [onFile], [payout], [profile],
            [onFile, payout], [oneTime, profile], [onFile, payout, profile],
        ]
        for actions in requests {
            let label = CashAppPayButtonLabel(actions: actions)
            XCTAssertNotEqual(label, .buy)
            XCTAssertNotEqual(label, .checkout)
        }
    }
}
