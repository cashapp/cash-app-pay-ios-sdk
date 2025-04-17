//
//  CashAppPaymentMethod.swift
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
public class CashAppPaymentMethod: UIView {

    // MARK: - Private Properties

    private let paymentMethodView: CashAppPaymentMethodView

    // MARK: - Public Properties

    /// View size of the view
    public var size: SizingCategory {
        get { paymentMethodView.viewModel.size }
        set { paymentMethodView.viewModel.size = newValue }
    }

    /// Cash Tag representing the customer.
    public var cashTag: String {
        get { paymentMethodView.viewModel.cashTag }
        set { paymentMethodView.viewModel.cashTag = newValue }
    }

    // MARK: - Lifecycle

    /**
     Initializes a view with the Cash App logo on the left and the Cash Tag
     representing the customer on the right or the bottom.

     - Parameters:
     - size: The size of the view where the `small` is vertically stacked while `large` is horizontally stacked.
     Defaults to `large`.
     - cashTag: The Customer ID. Defaults to `nil`.
     - usePolychromeAsset: Toggle usage of polychrome UI
     */
    public init(size: SizingCategory = .large, cashTag: String = "", usePolychromeAsset: Bool = false) {
        self.paymentMethodView = CashAppPaymentMethodView(
            size: size,
            cashTag: cashTag,
            usePolychromeAsset: usePolychromeAsset
        )
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

    /// Set the Cash Tag text color
    public func setCashTagTextColor(_ color: UIColor) {
        guard let uiColor = color.swiftUIColor else { return }
        paymentMethodView.viewModel.cashTagTextColor = uiColor
    }

    /// Set the Cash Tag font
    public func setCashTagFont(_ font: UIFont) {
        paymentMethodView.viewModel.cashTagFont = Font(font)
    }
}

// MARK: - View Building

@available(iOS 13.0, *)
private extension CashAppPaymentMethod {
    private func makeView() -> UIView? {
        guard let view = UIHostingController(rootView: paymentMethodView).view else {
            return nil
        }
        view.layer.cornerRadius = CashAppPaymentMethodView.Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
