//
//  CashAppPaymentMethodCompatibilityTests.swift
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

@testable import PayKitUI
import XCTest

/// Calls written against the 2.0.0 payment method API must still compile and show the "Cash App Pay" logo.
@available(iOS 13.0, *)
class CashAppPaymentMethodCompatibilityTests: XCTestCase {

    // MARK: - UIKit

    func test_payment_method_without_logo_uses_cashAppPay() {
        let paymentMethods = [
            CashAppPaymentMethod(),
            CashAppPaymentMethod(size: .small),
            CashAppPaymentMethod(size: .large, cashTag: "$jack"),
            CashAppPaymentMethod(size: .small, cashTag: "$jack", usePolychromeAsset: true),
        ]
        for paymentMethod in paymentMethods {
            XCTAssertEqual(paymentMethod.label, .cashAppPay)
        }
    }

    func test_payment_method_with_logo() {
        let paymentMethod = CashAppPaymentMethod(size: .small, cashTag: "$jack", label: .cashApp)
        XCTAssertEqual(paymentMethod.label, .cashApp)
        XCTAssertEqual(paymentMethod.size, .small)
        XCTAssertEqual(paymentMethod.cashTag, "$jack")

        paymentMethod.label = .cashAppPay
        XCTAssertEqual(paymentMethod.label, .cashAppPay)
    }

    // MARK: - SwiftUI

    func test_view_without_logo_uses_cashAppPay() {
        let views = [
            CashAppPaymentMethodView(cashTag: "$jack"),
            CashAppPaymentMethodView(size: .small, cashTag: "$jack"),
            CashAppPaymentMethodView(size: .large, cashTag: "$jack", usePolychromeAsset: true),
        ]
        for view in views {
            XCTAssertEqual(view.viewModel.label, .cashAppPay)
        }
    }

    func test_view_with_logo() {
        let view = CashAppPaymentMethodView(size: .small, cashTag: "$jack", usePolychromeAsset: true, label: .cashApp)
        XCTAssertEqual(view.viewModel.label, .cashApp)
        XCTAssertEqual(view.viewModel.size, .small)
        XCTAssertTrue(view.viewModel.usePolychromeAsset)
    }
}
