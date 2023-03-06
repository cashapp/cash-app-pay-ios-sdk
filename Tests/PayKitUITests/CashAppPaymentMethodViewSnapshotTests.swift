//
//  CashAppPaymentMethodViewSnapshotTests.swift
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

import PayKitUI
import SnapshotTesting
import SwiftUI

@available(iOS 13.0, *)
class CashAppPaymentMethodViewSnapshotTests: BaseSnapshotTestCase {
    func test_small_button() {
        assertSnapshot(
            matching: CashAppPaymentMethodView(size: .small, cashTag: "$jack").frame(height: 100),
            as: .image(on: .iPhone8)
        )
    }

    func test_large_button() {
        assertSnapshot(
            matching: CashAppPaymentMethodView(size: .large, cashTag: "$jack"),
            as: .image(on: .iPhone8)
        )
    }

    func test_dark_mode() {
        assertSnapshot(
            matching: CashAppPaymentMethodView(size: .large, cashTag: "$jack"),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_text_custom_font() {
        assertSnapshot(
            matching: CashAppPaymentMethodView(
                size: .large,
                cashTag: "$jack",
                cashTagFont: Font.caption,
                cashTagTextColor: .red
            ),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_minimum_size() {
        let view = HStack {
            Spacer().frame(idealWidth: .infinity)
            CashAppPaymentMethodView(size: .small, cashTag: "$jack")
            Spacer().frame(idealWidth: .infinity)
        }
        assertSnapshot(matching: view, as: .image(on: .iPhone8, userInterfaceStyle: .dark))
    }
}
