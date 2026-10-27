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

@available(iOS 13.0, *)
class CashAppPayButtonViewSnapshotTests: BaseSnapshotTestCase {
    func test_small_button() {
        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, size: .small, onClickHandler: {}),
            as: .image(on: .iPhone8)
        )
    }

    func test_large_button() {
        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, size: .large, onClickHandler: {}),
            as: .image(on: .iPhone8)
        )
    }

    func test_button_disabled() {
        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, size: .large, isEnabled: false, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .light)
        )

        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, size: .large, isEnabled: false, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )
    }

    func test_dark_mode() {
        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, size: .large, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark)
        )

        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, style: .black, size: .large, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark),
            named: "black"
        )
    }

    func test_default_label() {
        assertSnapshot(
            matching: CashAppPayButtonView(onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .light),
            named: "light"
        )

        assertSnapshot(
            matching: CashAppPayButtonView(onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark),
            named: "dark"
        )
    }

    func test_monochrome_automatic() {
        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, style: .monochromeAutomatic, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .light),
            named: "light"
        )

        assertSnapshot(
            matching: CashAppPayButtonView(label: .pay, style: .monochromeAutomatic, onClickHandler: {}),
            as: .image(on: .iPhone8, userInterfaceStyle: .dark),
            named: "dark"
        )
    }

    func test_labels_and_styles() {
        let styles: [CashAppPayButtonStyle] = [.black, .white, .monochromeBlack, .monochromeWhite, .green]
        for style in styles {
            for label in CashAppPayButtonLabel.allCases {
                assertSnapshot(
                    matching: CashAppPayButtonView(label: label, style: style, onClickHandler: {}),
                    as: .image(on: .iPhone8),
                    named: "\(label)-\(style)"
                )
            }
        }
    }

    func test_spanish_labels() {
        let labels: [CashAppPayButtonLabel] = [.pay, .buy, .cashOut, .checkout, .continue, .connect]
        let styles: [CashAppPayButtonStyle] = [.black, .white, .monochromeBlack, .monochromeWhite, .green]
        for style in styles {
            for label in labels {
                assertSnapshot(
                    matching: CashAppPayButtonView(label: label, style: style, onClickHandler: {})
                        .environment(\.locale, Locale(identifier: "es")),
                    as: .image(on: .iPhone8),
                    named: "\(label)-\(style)"
                )
            }
        }
    }

    func test_minimum_size() {
        let smallButton = HStack {
            Spacer().frame(idealWidth: .infinity)
            CashAppPayButtonView(label: .pay, size: .small, onClickHandler: {})
            Spacer().frame(idealWidth: .infinity)
        }
        assertSnapshot(matching: smallButton, as: .image(on: .iPhone8))

        let largeButton = HStack {
            Spacer().frame(idealWidth: .infinity)
            CashAppPayButtonView(label: .pay, size: .large, onClickHandler: {})
            Spacer().frame(idealWidth: .infinity)
        }
        assertSnapshot(matching: largeButton, as: .image(on: .iPhone8))
    }
}
