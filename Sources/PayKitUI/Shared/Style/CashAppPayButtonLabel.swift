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

/// The call to action shown on a `CashAppPayButton`.
///
/// The default, `.cashApp`, shows the Cash App icon and "Cash App". Pass another label to show a call to action,
/// for example `.checkout` on a checkout screen.
public enum CashAppPayButtonLabel: CaseIterable {
    /// "Cash App", with no call to action. This is the default.
    case cashApp
    /// "Pay with Cash App", for payments.
    case pay
    /// "Buy with Cash App", for buy-now payments, for example a "Buy now" button on a product page.
    case buy
    /// "Cash out with Cash App", for payouts.
    case cashOut
    /// "Checkout with Cash App", for checkout screens.
    case checkout
    /// "Continue with Cash App", for requests where the customer authorizes several kinds of actions.
    case `continue`
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
