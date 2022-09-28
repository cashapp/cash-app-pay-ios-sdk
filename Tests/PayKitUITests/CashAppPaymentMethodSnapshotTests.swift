//
//  CashAppPaymentMethodSnapshotTests.swift
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
import UIKit

class CashAppPaymentMethodSnapshotTests: BaseSnapshotTestCase {
    func test_small_payment_method() {
        let paymentMethod = CashAppPaymentMethod(size: .small)
        paymentMethod.cashTag = "$jack"
        assertSnapshot(matching: paymentMethod, as: .image(centeredIn: .iPhone8))
    }

    func test_large_payment_method() {
        let paymentMethod = CashAppPaymentMethod(size: .large)
        paymentMethod.cashTag = "$jack"
        assertSnapshot(matching: paymentMethod, as: .image(centeredIn: .iPhone8))
    }

    func test_dark_mode() {
        let paymentMethod = CashAppPaymentMethod(size: .large)
        assertSnapshot(matching: paymentMethod, as: .image(centeredIn: .iPhone8, userInterfaceStyle: .dark))
    }

    func test_text_custom_font() {
        let paymentMethod = CashAppPaymentMethod(size: .large)
        paymentMethod.cashTag = "$jack"
        paymentMethod.setCashTagFont(.italicSystemFont(ofSize: 12))
        paymentMethod.setCashTagTextColor(.red)
        assertSnapshot(matching: paymentMethod, as: .image(centeredIn: .iPhone8, userInterfaceStyle: .dark))
    }

    func test_expands_full_width() {
        let paymentMethod = CashAppPaymentMethod(size: .large)
        paymentMethod.cashTag = "$jack"

        let container = UIView()
        paymentMethod.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(paymentMethod)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: paymentMethod.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: paymentMethod.trailingAnchor),
            container.centerYAnchor.constraint(equalTo: paymentMethod.centerYAnchor),
        ])
        assertSnapshot(matching: container, as: .image(filling: .iPhone8, userInterfaceStyle: .dark))
    }
}
