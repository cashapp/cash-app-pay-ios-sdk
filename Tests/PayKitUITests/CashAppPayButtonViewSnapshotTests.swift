//
//  CashAppPayButtonViewSnapshotTests.swift
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

class CashAppPayButtonViewSnapshotTests: BaseSnapshotTestCase {
    func test_small_button() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .small, onClickHandler: {}),
            as: .image(on: .iPhone8)
        )
    }

    func test_large_button() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .large, onClickHandler: {}),
            as: .image(on: .iPhone8)
        )
    }

    func test_button_disabled_light_mode() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .large, isEnabled: false, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .light)
        )
    }

    func test_button_disabled_dark_mode() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .large, isEnabled: false, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_button_disabled() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .large, isEnabled: false, onClickHandler: {}),
            as: .image(on: .iPhone8)
        )
    }

    func test_dark_mode() {
        assertSnapshot(
            matching: CashAppPayButtonView(size: .large, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_minimum_size() {
        let smallButton = HStack {
            Spacer().frame(idealWidth: .infinity)
            CashAppPayButtonView(size: .small, onClickHandler: {})
            Spacer().frame(idealWidth: .infinity)
        }
        assertSnapshot(matching: smallButton, as: .image(on: .iPhone8))

        let largeButton = HStack {
            Spacer().frame(idealWidth: .infinity)
            CashAppPayButtonView(size: .large, onClickHandler: {})
            Spacer().frame(idealWidth: .infinity)
        }
        assertSnapshot(matching: largeButton, as: .image(on: .iPhone8))
    }
}
