//
//  BaseSnapshotTestCase.swift
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

import SnapshotTesting
import SwiftUI
import XCTest

class BaseSnapshotTestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        isRecording = false
    }
}

// MARK: - SnapshotTesting Extensions

private let lowPrecision: Float = 0.95
private let viewBackground: UIColor = .darkGray

extension Snapshotting where Value: UIView, Format ==  UIImage {
    public static func image(
        filling config: ViewImageConfig,
        userInterfaceStyle: UIUserInterfaceStyle = .light
    ) -> Snapshotting {
        Snapshotting<UIViewController, UIImage>.image(
            on: config,
            precision: lowPrecision,
            traits: UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        ).pullback { view in
            let controller = UIViewController()
            controller.view.backgroundColor = .gray
            controller.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
                view.topAnchor.constraint(equalTo: controller.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
            ])
            controller.view.frame = UIScreen.main.bounds
            return controller
        }
    }

    public static func image(
        centeredIn config: ViewImageConfig,
        userInterfaceStyle: UIUserInterfaceStyle = .light
    ) -> Snapshotting {
        Snapshotting<UIViewController, UIImage>.image(
            on: config,
            precision: lowPrecision,
            traits: UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        ).pullback { view in
            let controller = UIViewController()
            controller.view.backgroundColor = .gray
            controller.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor),
            ])
            controller.view.frame = UIScreen.main.bounds
            return controller
        }
    }
}

extension Snapshotting where Value: View, Format ==  UIImage {
    public static func image(
        on config: ViewImageConfig,
        userInterfaceStyle: UIUserInterfaceStyle = .light
    ) -> Snapshotting {
        Snapshotting<UIViewController, UIImage>.image(
            on: config,
            precision: lowPrecision,
            traits: UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        ).pullback { view in
            let controller = UIHostingController.init(rootView: view)
            controller.view.backgroundColor = .darkGray
            controller.view.frame = UIScreen.main.bounds
            return controller
        }
    }
}
