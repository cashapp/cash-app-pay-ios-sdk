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

    // MARK: - Private Properties

    private let onClickHandler: () -> Void

    // MARK: - Lifecycle

    /**
     Initializes a button with a Cash App call to action.

     - Parameters:
     - label: The call to action shown on the button. Defaults to `cashApp`, which shows the Cash App icon and "Cash App".
       Pass another label, such as `.pay` or `.checkout`, to show a call to action.
     - style: The color variant of the button. Defaults to `automatic`, which follows the system appearance.
     - size: The size of the button. Defaults to `large`.
     - isEnabled: True if the button is enabled.
     - onClickHandler: The handler called when the button is tapped.
     */
    public init(
        label: CashAppPayButtonLabel = .cashApp,
        style: CashAppPayButtonStyle = .automatic,
        size: SizingCategory = .large,
        isEnabled: Bool = true,
        onClickHandler: @escaping () -> Void
    ) {
        self.viewModel = ViewModel(label: label, style: style, size: size, isEnabled: isEnabled)
        self.onClickHandler = onClickHandler
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

    /// The color art: the text and the green icon, drawn for a black or a white background.
    private var colorAsset: SwiftUI.Image {
        let isWhite = resolvedStyle == .white
        switch viewModel.label {
        case .cashApp: return (isWhite ? Asset.Images.cashAppWhite : Asset.Images.cashAppBlack).swiftUIImage
        case .pay: return (isWhite ? Asset.Images.payWithWhite : Asset.Images.payWithBlack).swiftUIImage
        case .buy: return (isWhite ? Asset.Images.buyWithWhite : Asset.Images.buyWithBlack).swiftUIImage
        case .cashOut:
            return (isWhite ? Asset.Images.cashOutWithWhite : Asset.Images.cashOutWithBlack).swiftUIImage
        case .checkout:
            return (isWhite ? Asset.Images.checkoutWithWhite : Asset.Images.checkoutWithBlack).swiftUIImage
        case .continue:
            return (isWhite ? Asset.Images.continueWithWhite : Asset.Images.continueWithBlack).swiftUIImage
        }
    }

    /// The single-color template art, tinted with `monochromeTint`.
    private var monochromeAsset: SwiftUI.Image {
        switch viewModel.label {
        case .cashApp: return Asset.Images.cashAppMono.swiftUIImage
        case .pay: return Asset.Images.payWithMono.swiftUIImage
        case .buy: return Asset.Images.buyWithMono.swiftUIImage
        case .cashOut: return Asset.Images.cashOutWithMono.swiftUIImage
        case .checkout: return Asset.Images.checkoutWithMono.swiftUIImage
        case .continue: return Asset.Images.continueWithMono.swiftUIImage
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
        switch viewModel.label {
        case .cashApp: return "Cash App"
        case .pay: return "Pay with Cash App"
        case .buy: return "Buy with Cash App"
        case .cashOut: return "Cash out with Cash App"
        case .checkout: return "Checkout with Cash App"
        case .continue: return "Continue with Cash App"
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
