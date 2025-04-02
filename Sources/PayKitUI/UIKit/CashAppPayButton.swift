//
//  CashAppPayButton.swift
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

import SwiftUI

@available(iOS 13.0, *)
public class CashAppPayButton: UIView {

    // MARK: - Public Properties

    /// View size of the view
    public var size: SizingCategory {
        get { cashAppButton.viewModel.size }
        set { cashAppButton.viewModel.size = newValue }
    }

    /// True if the button is enabled
    public var isEnabled: Bool {
        get { cashAppButton.viewModel.isEnabled }
        set { cashAppButton.viewModel.isEnabled = newValue }
    }

    // MARK: - Private Properties

    private let onClickHandler: () -> Void
    private let cashAppButton: CashAppPayButtonView

    // MARK: - Life Cycle

    /**
     Initializes a button with the Cash App Logo and name.

     - Parameters:
     - size: The size of the button. Defaults to `large`.
     - onClickHandler: The handler called when the button is tapped.
     */
    public init(size: SizingCategory = .large, onClickHandler: @escaping () -> Void, usePolyChoromeAsset: Bool = false) {
        self.cashAppButton = CashAppPayButtonView(size: size, onClickHandler: onClickHandler, usePolyChromeAsset: usePolyChoromeAsset)
        self.onClickHandler = onClickHandler
        super.init(frame: .zero)
        guard let view = makeView() else { return }
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Building

@available(iOS 13.0, *)
private extension CashAppPayButton {
    private func makeView() -> UIView? {
        guard let view = UIHostingController(rootView: cashAppButton).view else {
            return nil
        }
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
