//
//  CashAppPayButtonCompatibilityTests.swift
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

/// Calls written against the 2.0.0 button API must still compile and pick the expected initializer.
/// Marked deprecated so its intentional calls to the deprecated initializers don't warn,
/// because `pod lib lint` fails on warnings.
@available(iOS 13.0, *)
@available(*, deprecated, message: "Exercises the deprecated usePolychromeAsset initializers")
class CashAppPayButtonCompatibilityTests: XCTestCase {

    // MARK: - UIKit

    func test_button_usePolychromeAsset_true_uses_green() {
        let button = CashAppPayButton(size: .small, onClickHandler: {}, usePolychromeAsset: true)
        XCTAssertEqual(button.label, .cashAppPay)
        XCTAssertEqual(button.style, .green)
        XCTAssertEqual(button.size, .small)
    }

    func test_button_usePolychromeAsset_false_uses_monochromeAutomatic() {
        let button = CashAppPayButton(onClickHandler: {}, usePolychromeAsset: false)
        XCTAssertEqual(button.label, .cashAppPay)
        XCTAssertEqual(button.style, .monochromeAutomatic)
        XCTAssertEqual(button.size, .large)
    }

    func test_button_without_usePolychromeAsset_uses_new_defaults() {
        let buttons = [
            CashAppPayButton(onClickHandler: {}),
            CashAppPayButton(size: .small, onClickHandler: {}),
            CashAppPayButton {},
            CashAppPayButton(size: .small) {},
        ]
        for button in buttons {
            XCTAssertEqual(button.label, .cashAppPay)
            XCTAssertEqual(button.style, .automatic)
        }
    }

    // MARK: - SwiftUI

    func test_view_usePolychromeAsset_true_uses_green() {
        let view = CashAppPayButtonView(size: .large, isEnabled: false, onClickHandler: {}, usePolychromeAsset: true)
        XCTAssertEqual(view.viewModel.label, .cashAppPay)
        XCTAssertEqual(view.viewModel.style, .green)
        XCTAssertEqual(view.viewModel.size, .large)
        XCTAssertFalse(view.viewModel.isEnabled)
    }

    func test_view_usePolychromeAsset_false_uses_monochromeAutomatic() {
        let view = CashAppPayButtonView(onClickHandler: {}, usePolychromeAsset: false)
        XCTAssertEqual(view.viewModel.label, .cashAppPay)
        XCTAssertEqual(view.viewModel.style, .monochromeAutomatic)
        XCTAssertTrue(view.viewModel.isEnabled)
    }

    func test_view_without_usePolychromeAsset_uses_new_defaults() {
        let views = [
            CashAppPayButtonView(onClickHandler: {}),
            CashAppPayButtonView(size: .small, isEnabled: false, onClickHandler: {}),
            CashAppPayButtonView {},
            CashAppPayButtonView(isEnabled: false) {},
        ]
        for view in views {
            XCTAssertEqual(view.viewModel.label, .cashAppPay)
            XCTAssertEqual(view.viewModel.style, .automatic)
        }
    }
}
