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

    func test_payments_use_pay_with() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime]), .payWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [onFile]), .payWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime, onFile]), .payWith)
    }

    func test_payouts_use_cash_out_with() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [payout]), .cashOutWith)
    }

    func test_profile_sharing_mixed_actions_and_no_actions_use_continue_with() {
        XCTAssertEqual(CashAppPayButtonLabel(actions: [profile]), .continueWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [onFile, payout]), .continueWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [oneTime, profile]), .continueWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: [payout, profile]), .continueWith)
        XCTAssertEqual(CashAppPayButtonLabel(actions: []), .continueWith)
    }

    func test_checkout_with_is_only_set_explicitly() {
        let requests: [[PaymentAction]] = [
            [], [oneTime], [onFile], [payout], [profile],
            [onFile, payout], [oneTime, profile], [onFile, payout, profile],
        ]
        for actions in requests {
            let label = CashAppPayButtonLabel(actions: actions)
            XCTAssertNotEqual(label, .checkoutWith)
        }
    }
}
