//
//  CashAppPayButtonView.swift
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
public struct CashAppPayButtonView: View {

    // MARK: - Public Properties

    @ObservedObject public var viewModel: ViewModel

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale

    // MARK: - Private Properties

    private let onClickHandler: () -> Void

    // MARK: - Lifecycle

    /**
     Initializes a button with a Cash App call to action.

     - Parameters:
     - label: The call to action shown on the button. Defaults to `cashAppPay`, which shows the Cash App icon
       and "Cash App Pay". Pass another label, such as `.pay` or `.checkout`, to show a call to action.
     - style: The color variant of the button. Defaults to `automatic`, which follows the system appearance.
     - size: The size of the button. Defaults to `large`.
     - isEnabled: True if the button is enabled.
     - onClickHandler: The handler called when the button is tapped.
     */
    public init(
        label: CashAppPayButtonLabel = .cashAppPay,
        style: CashAppPayButtonStyle = .automatic,
        size: SizingCategory = .large,
        isEnabled: Bool = true,
        onClickHandler: @escaping () -> Void
    ) {
        self.viewModel = ViewModel(label: label, style: style, size: size, isEnabled: isEnabled)
        self.onClickHandler = onClickHandler
    }

    /**
     Initializes a button with the Cash App icon and "Cash App Pay".

     - Parameters:
     - size: The size of the button. Defaults to `large`.
     - isEnabled: True if the button is enabled.
     - onClickHandler: The handler called when the button is tapped.
     - usePolychromeAsset: `true` uses the `green` style. `false` uses the `monochromeAutomatic` style.

     - Note: Deprecated. Use `init(label:style:size:isEnabled:onClickHandler:)` instead: `style: .green` replaces
       `usePolychromeAsset: true`, and `style: .monochromeAutomatic` matches `usePolychromeAsset: false`.
     */
    @available(
        *,
        deprecated,
        message: "Use init(label:style:size:isEnabled:onClickHandler:); style: .green replaces usePolychromeAsset: true"
    )
    @_disfavoredOverload
    public init(
        size: SizingCategory = .large,
        isEnabled: Bool = true,
        onClickHandler: @escaping () -> Void,
        usePolychromeAsset: Bool = false
    ) {
        self.init(
            label: .cashAppPay,
            style: usePolychromeAsset ? .green : .monochromeAutomatic,
            size: size,
            isEnabled: isEnabled,
            onClickHandler: onClickHandler
        )
    }

    public var body: some View {
        HStack {
            buttonView
                .padding(Constants.buttonPadding)
        }.background(Color.clear)
    }

    private var buttonView: some View {
        Button(action: onClickHandler) {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(backgroundColor)
                if hasOutline {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .strokeBorder(Constants.black, lineWidth: Constants.outlineWidth)
                }
                labelView
            }
        }
        .accessibility(label: Text(accessibilityLabel))
        .opacity(viewModel.isEnabled ? Constants.opaque : Constants.disabledOpacity)
        .disabled(!viewModel.isEnabled)
        .frame(
            minWidth: minButtonWidth,
            maxWidth: .infinity,
            minHeight: fixedHeight,
            maxHeight: fixedHeight
        )
    }

    @ViewBuilder
    private var labelView: some View {
        if let tint = monochromeTint {
            monochromeAsset
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(tint)
                .frame(height: labelHeight)
        } else {
            colorAsset
                .resizable()
                .scaledToFit()
                .frame(height: labelHeight)
        }
    }

    /// The style after resolving the system appearance for the automatic styles.
    private var resolvedStyle: CashAppPayButtonStyle {
        switch viewModel.style {
        case .automatic: return colorScheme == .dark ? .white : .black
        case .monochromeAutomatic: return colorScheme == .dark ? .monochromeWhite : .monochromeBlack
        case .black, .white, .monochromeBlack, .monochromeWhite, .green: return viewModel.style
        }
    }

    /// True when the environment locale's language is Spanish, in any region. The call-to-action labels are then
    /// shown in Spanish. The `cashAppPay` and `cashApp` labels are brand names and look the same in every language.
    private var isSpanish: Bool {
        locale.languageCode == "es"
    }

    /// The color art: the text and the green icon, drawn for a black or a white background.
    private var colorAsset: SwiftUI.Image {
        let isWhite = resolvedStyle == .white
        switch (viewModel.label, isSpanish) {
        case (.cashAppPay, _):
            return (isWhite ? Asset.Images.cashAppPayWhite : Asset.Images.cashAppPayBlack).swiftUIImage
        case (.cashApp, _): return (isWhite ? Asset.Images.cashAppWhite : Asset.Images.cashAppBlack).swiftUIImage
        case (.pay, false): return (isWhite ? Asset.Images.payWithWhite : Asset.Images.payWithBlack).swiftUIImage
        case (.pay, true): return (isWhite ? Asset.Images.payWithWhiteEs : Asset.Images.payWithBlackEs).swiftUIImage
        case (.buy, false): return (isWhite ? Asset.Images.buyWithWhite : Asset.Images.buyWithBlack).swiftUIImage
        case (.buy, true): return (isWhite ? Asset.Images.buyWithWhiteEs : Asset.Images.buyWithBlackEs).swiftUIImage
        case (.cashOut, false):
            return (isWhite ? Asset.Images.cashOutWithWhite : Asset.Images.cashOutWithBlack).swiftUIImage
        case (.cashOut, true):
            return (isWhite ? Asset.Images.cashOutWithWhiteEs : Asset.Images.cashOutWithBlackEs).swiftUIImage
        case (.checkout, false):
            return (isWhite ? Asset.Images.checkoutWithWhite : Asset.Images.checkoutWithBlack).swiftUIImage
        case (.checkout, true):
            return (isWhite ? Asset.Images.checkoutWithWhiteEs : Asset.Images.checkoutWithBlackEs).swiftUIImage
        case (.continue, false):
            return (isWhite ? Asset.Images.continueWithWhite : Asset.Images.continueWithBlack).swiftUIImage
        case (.continue, true):
            return (isWhite ? Asset.Images.continueWithWhiteEs : Asset.Images.continueWithBlackEs).swiftUIImage
        case (.connect, false):
            return (isWhite ? Asset.Images.connectToWhite : Asset.Images.connectToBlack).swiftUIImage
        case (.connect, true):
            return (isWhite ? Asset.Images.connectToWhiteEs : Asset.Images.connectToBlackEs).swiftUIImage
        }
    }

    /// The single-color template art, tinted with `monochromeTint`.
    private var monochromeAsset: SwiftUI.Image {
        switch (viewModel.label, isSpanish) {
        case (.cashAppPay, _): return Asset.Images.cashAppPayMono.swiftUIImage
        case (.cashApp, _): return Asset.Images.cashAppMono.swiftUIImage
        case (.pay, false): return Asset.Images.payWithMono.swiftUIImage
        case (.pay, true): return Asset.Images.payWithMonoEs.swiftUIImage
        case (.buy, false): return Asset.Images.buyWithMono.swiftUIImage
        case (.buy, true): return Asset.Images.buyWithMonoEs.swiftUIImage
        case (.cashOut, false): return Asset.Images.cashOutWithMono.swiftUIImage
        case (.cashOut, true): return Asset.Images.cashOutWithMonoEs.swiftUIImage
        case (.checkout, false): return Asset.Images.checkoutWithMono.swiftUIImage
        case (.checkout, true): return Asset.Images.checkoutWithMonoEs.swiftUIImage
        case (.continue, false): return Asset.Images.continueWithMono.swiftUIImage
        case (.continue, true): return Asset.Images.continueWithMonoEs.swiftUIImage
        case (.connect, false): return Asset.Images.connectToMono.swiftUIImage
        case (.connect, true): return Asset.Images.connectToMonoEs.swiftUIImage
        }
    }

    /// The tint of the monochrome art, or `nil` when the style uses the color art.
    private var monochromeTint: Color? {
        switch resolvedStyle {
        case .monochromeBlack: return .white
        case .monochromeWhite: return Constants.pureBlack
        case .green: return Constants.black
        default: return nil
        }
    }

    private var backgroundColor: Color {
        switch resolvedStyle {
        case .white, .monochromeWhite: return .white
        case .green: return Constants.green
        default: return Constants.black
        }
    }

    private var hasOutline: Bool {
        resolvedStyle == .white || resolvedStyle == .monochromeWhite
    }

    private var accessibilityLabel: String {
        switch (viewModel.label, isSpanish) {
        case (.cashAppPay, _): return "Cash App Pay"
        case (.cashApp, _): return "Cash App"
        case (.pay, false): return "Pay with Cash App"
        case (.pay, true): return "Pagar con Cash App"
        case (.buy, false): return "Buy with Cash App"
        case (.buy, true): return "Comprar con Cash App"
        case (.cashOut, false): return "Cash out with Cash App"
        case (.cashOut, true): return "Retirar con Cash App"
        case (.checkout, false): return "Checkout with Cash App"
        case (.checkout, true): return "Finalizar compra con Cash App"
        case (.continue, false): return "Continue with Cash App"
        case (.continue, true): return "Continuar con Cash App"
        case (.connect, false): return "Connect to Cash App"
        case (.connect, true): return "Conectar con Cash App"
        }
    }

    private var labelHeight: CGFloat {
        switch viewModel.size {
        case .small: return Constants.labelHeightSmall
        case .large: return Constants.labelHeightLarge
        }
    }

    private var minButtonWidth: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallButtonWidth
        case .large: return Constants.largeButtonWidth
        }
    }

    private var fixedHeight: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallHeight
        case .large: return Constants.largeHeight
        }
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 8

        static let largeHeight: CGFloat = 48
        static let smallHeight: CGFloat = 30

        static let largeButtonWidth: CGFloat = 320
        static let smallButtonWidth: CGFloat = 221

        static let labelHeightLarge: CGFloat = 24
        static let labelHeightSmall: CGFloat = 16

        static let buttonPadding: CGFloat = 10

        static let outlineWidth: CGFloat = 1

        static let black = Color(red: 16 / 255, green: 16 / 255, blue: 16 / 255)
        static let pureBlack = Color(red: 0, green: 0, blue: 0)
        static let green = Color(red: 0, green: 214 / 255, blue: 79 / 255)

        static let opaque: Double = 1
        static let disabledOpacity: Double = 0.3
    }
}

// MARK: - View Model

@available(iOS 13.0, *)
extension CashAppPayButtonView {
    public class ViewModel: ObservableObject {
        @Published var label: CashAppPayButtonLabel
        @Published var style: CashAppPayButtonStyle
        @Published var size: SizingCategory
        @Published var isEnabled: Bool
        init(label: CashAppPayButtonLabel, style: CashAppPayButtonStyle, size: SizingCategory, isEnabled: Bool) {
            self.label = label
            self.style = style
            self.size = size
            self.isEnabled = isEnabled
        }
    }
}

@available(iOS 13.0, *)
struct CashButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(CashAppPayButtonStyle.allCases, id: \.self) { style in
                ForEach(CashAppPayButtonLabel.allCases, id: \.self) { label in
                    CashAppPayButtonView(label: label, style: style, onClickHandler: {})
                }
            }
            CashAppPayButtonView(size: .small, onClickHandler: {})
            CashAppPayButtonView(isEnabled: false, onClickHandler: {})
        }.background(Color.gray)
    }
}
