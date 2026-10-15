//
//  CashAppPayButtonLabel.swift
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

import Foundation
import PayKit

/// The call to action shown on a `CashAppPayButton`.
///
/// To pick the label for a customer request, use `CashAppPayButtonLabel(actions: customerRequest.actions)`.
/// To override it, pass a label directly, for example `.checkoutWith` on a checkout screen.
public enum CashAppPayButtonLabel: CaseIterable {
    /// "Pay with Cash App", for payments.
    case payWith
    /// "Buy with Cash App", for buy-now payments, for example a "Buy now" button on a product page.
    /// `init(actions:)` never returns it; set it explicitly.
    case buyWith
    /// "Cash out with Cash App", for payouts.
    case cashOutWith
    /// "Checkout with Cash App". `init(actions:)` never returns it; set it explicitly.
    case checkoutWith
    /// "Continue with Cash App", for requests that combine different kinds of actions or have none.
    case continueWith

    /// Returns `.payWith` when every action is a payment, `.cashOutWith` when every action is a payout,
    /// and `.continueWith` otherwise.
    public init(actions: [PaymentAction]) {
        let types = actions.map(\.type)
        if types.isEmpty {
            self = .continueWith
        } else if types.allSatisfy({ $0 == .ONE_TIME_PAYMENT || $0 == .ON_FILE_PAYMENT }) {
            self = .payWith
        } else if types.allSatisfy({ $0 == .ON_FILE_PAYOUT }) {
            self = .cashOutWith
        } else {
            self = .continueWith
        }
    }
}

/// The color variant of a `CashAppPayButton`.
public enum CashAppPayButtonStyle: CaseIterable {
    /// White label and green Cash App icon on a black background.
    case black
    /// Black label and green Cash App icon on a white background with a thin black outline.
    case white
    /// White label and white Cash App icon on a black background.
    case monochromeBlack
    /// Black label and black Cash App icon on a white background with a thin black outline.
    case monochromeWhite
    /// Black label and black Cash App icon on a Cash App green background.
    case green
    /// Follows the system appearance: `.black` in light mode and `.white` in dark mode.
    case automatic
    /// Follows the system appearance: `.monochromeBlack` in light mode and `.monochromeWhite` in dark mode.
    case monochromeAutomatic
}
