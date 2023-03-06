//
//  CashAppPayButtonSnapshotTests.swift
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
import XCTest

@available(iOS 13.0, *)
class CashAppPayButtonSnapshotTests: BaseSnapshotTestCase {
    func test_small_button() {
        assertSnapshot(matching: CashAppPayButton(size: .small, onClickHandler: {}), as: .image(centeredIn: .iPhone8))
    }

    func test_large_button() {
        assertSnapshot(matching: CashAppPayButton(size: .large, onClickHandler: {}), as: .image(centeredIn: .iPhone8))
    }

    func test_button_disabled() {
        let lightButton = CashAppPayButton(size: .large, onClickHandler: {})
         lightButton.isEnabled = false
         assertSnapshot(matching: lightButton, as: .image(centeredIn: .iPhone8, userInterfaceStyle: .light))

         let darkButton = CashAppPayButton(size: .large, onClickHandler: {})
         darkButton.isEnabled = false
         assertSnapshot(matching: darkButton, as: .image(centeredIn: .iPhone8, userInterfaceStyle: .dark))
    }

    func test_dark_mode() {
        assertSnapshot(
            matching: CashAppPayButton(onClickHandler: {}),
            as: .image(centeredIn: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_button_expands() {
        assertSnapshot(
            matching: CashAppPayButton(size: .large, onClickHandler: {}),
            as: .image(filling: .iPhone8, userInterfaceStyle: .dark)
        )
        assertSnapshot(
            matching: CashAppPayButton(size: .small, onClickHandler: {}),
            as: .image(filling: .iPhone8, userInterfaceStyle: .dark)
        )
    }
}
