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

    // MARK: - Private Properties

    private let onClickHandler: () -> Void

    // MARK: - Lifecycle

    /**
     Initializes a button with a Cash App call to action.

     - Parameters:
     - label: The call to action shown on the button. Use `CashAppPayButtonLabel(actions:)` to match a customer request.
       Pass `.checkoutWith` or `.continueWith` to override it.
     - style: The color variant of the button. Defaults to `black`.
     - size: The size of the button. Defaults to `large`.
     - isEnabled: True if the button is enabled.
     - onClickHandler: The handler called when the button is tapped.
     */
    public init(
        label: CashAppPayButtonLabel,
        style: CashAppPayButtonStyle = .black,
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
                currentAsset
                    .resizable()
                    .scaledToFit()
                    .frame(height: labelHeight)
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

    private var currentAsset: SwiftUI.Image {
        switch (viewModel.label, viewModel.style) {
        case (.payWith, .black): return Asset.Images.payWithBlack.swiftUIImage
        case (.payWith, .white): return Asset.Images.payWithWhite.swiftUIImage
        case (.cashOutWith, .black): return Asset.Images.cashOutWithBlack.swiftUIImage
        case (.cashOutWith, .white): return Asset.Images.cashOutWithWhite.swiftUIImage
        case (.connect, .black): return Asset.Images.connectBlack.swiftUIImage
        case (.connect, .white): return Asset.Images.connectWhite.swiftUIImage
        case (.checkoutWith, .black): return Asset.Images.checkoutWithBlack.swiftUIImage
        case (.checkoutWith, .white): return Asset.Images.checkoutWithWhite.swiftUIImage
        case (.continueWith, .black): return Asset.Images.continueWithBlack.swiftUIImage
        case (.continueWith, .white): return Asset.Images.continueWithWhite.swiftUIImage
        }
    }

    private var accessibilityLabel: String {
        switch viewModel.label {
        case .payWith: return "Pay with Cash App"
        case .cashOutWith: return "Cash out with Cash App"
        case .connect: return "Connect Cash App"
        case .checkoutWith: return "Checkout with Cash App"
        case .continueWith: return "Continue with Cash App"
        }
    }

    private var backgroundColor: Color {
        switch viewModel.style {
        case .black: return Constants.black
        case .white: return .white
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

        static let black = Color(red: 16 / 255, green: 16 / 255, blue: 16 / 255)

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
            CashAppPayButtonView(label: .payWith, size: .small, onClickHandler: {})
            CashAppPayButtonView(label: .payWith, isEnabled: false, onClickHandler: {})
        }.background(Color.gray)
    }
}
