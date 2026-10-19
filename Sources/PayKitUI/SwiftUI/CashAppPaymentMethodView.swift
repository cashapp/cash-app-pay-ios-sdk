//
//  CashAppPaymentMethodView.swift
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
import SwiftUI

@available(iOS 13.0, *)
public struct CashAppPaymentMethodView: View {

    // MARK: - Public Properties

    @ObservedObject public var viewModel: ViewModel

    @Environment(\.colorScheme) private var colorScheme

    private var currentAsset: SwiftUI.Image {
        switch viewModel.label {
        case .cashAppPay:
            return viewModel.usePolychromeAsset ?
                Asset.Images.polyChromeLogo.swiftUIImage :
                Asset.Images.monoChromeLogoReverse.swiftUIImage
        case .cashApp:
            return viewModel.usePolychromeAsset ?
                Asset.Images.cashAppLogoPolychrome.swiftUIImage :
                Asset.Images.cashAppLogoMonochrome.swiftUIImage
        }
    }

    private var currentColor: SwiftUI.Color {
        guard viewModel.usePolychromeAsset else {
            return Asset.Colors.surfaceSecondary.swiftUIColor
        }
        switch viewModel.label {
        case .cashAppPay:
            return Asset.Colors.polyChrome.swiftUIColor
        case .cashApp:
            return .black
        }
    }

    /// A custom cashtag color is always used as set. Without one, the cashtag uses `Constants.cashTagTextColor`,
    /// except on the green `cashAppPay` polychrome background in dark mode, where it is near-black like the logo's
    /// wordmark.
    private var cashTagTextColor: SwiftUI.Color {
        if let color = viewModel.cashTagTextColor {
            return color
        }
        let isOnGreen = viewModel.usePolychromeAsset && viewModel.label == .cashAppPay && colorScheme == .dark
        return isOnGreen ? Constants.cashTagOnGreenTextColor : Constants.cashTagTextColor
    }

    private var titleWidth: CGFloat {
        switch viewModel.label {
        case .cashAppPay:
            return Constants.cashAppPayTitleWidth
        case .cashApp:
            return Constants.cashAppTitleWidth
        }
    }

    // MARK: - Lifecycle

    /**
     Initializes a view with the Cash App Pay logo on the left and the Cash Tag representing
     the customer on the right or the bottom.

     - Parameters:
     - size: The size of the view where the `small` is vertically stacked while `large` is horizontally stacked.
     Defaults to `large`.
     - cashTag: The Customer ID. Defaults to `nil`.
     - cashTagFont: Cash Tag text font.
     - cashTagTextColor: Cash Tag text color. Defaults to `nil`, which uses `Constants.cashTagTextColor`, or near-black
       on the green `cashAppPay` polychrome background in dark mode.
     - usePolychromeAsset: Toggle usage of polychrome UI
     */
    public init(
        size: SizingCategory = .large,
        cashTag: String,
        cashTagFont: Font = Constants.cashTagFont,
        cashTagTextColor: Color? = nil,
        usePolychromeAsset: Bool = false
    ) {
        self.init(
            size: size,
            cashTag: cashTag,
            cashTagFont: cashTagFont,
            cashTagTextColor: cashTagTextColor,
            usePolychromeAsset: usePolychromeAsset,
            label: .cashAppPay
        )
    }

    /**
     Initializes a view with the logo for the given label on the left and the Cash Tag representing
     the customer on the right or the bottom.

     - Parameters:
     - size: The size of the view where the `small` is vertically stacked while `large` is horizontally stacked.
     Defaults to `large`.
     - cashTag: The Customer ID.
     - cashTagFont: Cash Tag text font.
     - cashTagTextColor: Cash Tag text color. Defaults to `nil`, which uses `Constants.cashTagTextColor`, or near-black
       on the green `cashAppPay` polychrome background in dark mode.
     - usePolychromeAsset: Toggle usage of polychrome UI
     - label: The label shown on the view. `cashAppPay` shows the "Cash App Pay" logo, the same as the initializer
       without `label`. `cashApp` shows the "Cash App" logo.
     */
    public init(
        size: SizingCategory = .large,
        cashTag: String,
        cashTagFont: Font = Constants.cashTagFont,
        cashTagTextColor: Color? = nil,
        usePolychromeAsset: Bool = false,
        label: CashAppPaymentMethodLabel
    ) {
        self.viewModel = ViewModel(
            size: size,
            cashTag: cashTag,
            cashTagFont: cashTagFont,
            cashTagTextColor: cashTagTextColor,
            usePolychromeAsset: usePolychromeAsset,
            label: label
        )
    }

    public var body: some View {
        switch viewModel.size {
        case .small:
            VStack(alignment: .leading, spacing: Constants.verticalTextSpacing) {
                currentAsset
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: titleWidth, height: Constants.titleHeight)
                    .offset(y: Constants.titleVerticalOffset)
                    .padding(
                        EdgeInsets(
                            top: Constants.verticalPadding,
                            leading: Constants.horizontalPadding,
                            bottom: .zero,
                            trailing: Constants.horizontalPadding
                        )
                    )
                cashTagText
                    .padding(
                    EdgeInsets(
                        top: .zero,
                        leading: Constants.cashTagInset,
                        bottom: Constants.verticalPadding,
                        trailing: .zero
                    )
                )
            }.background(currentColor)
                .cornerRadius(Constants.cornerRadius)
        case .large:
            HStack(alignment: .center) {
                currentAsset
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: titleWidth, height: Constants.titleHeight)
                    .padding(
                        EdgeInsets(
                            top: Constants.verticalPadding,
                            leading: Constants.horizontalPadding,
                            bottom: Constants.verticalPadding,
                            trailing: .zero
                        )
                    )
                Spacer()
                cashTagText
                    .padding(.trailing, Constants.horizontalPadding)
            }.background(currentColor)
                .cornerRadius(Constants.cornerRadius)
        }
    }

    private var cashTagText: some View {
        Text(viewModel.cashTag)
            .foregroundColor(cashTagTextColor)
            .font(viewModel.cashTagFont)
    }

    public enum Constants {
        public static let cashTagFont = Font.system(size: 14)
        public static let cashTagTextColor = Asset.Colors.textTernary.swiftUIColor

        static let cashTagOnGreenTextColor = Color(red: 0x10 / 255, green: 0x10 / 255, blue: 0x10 / 255)

        static let cashAppPayTitleWidth: CGFloat = 127
        static let cashAppTitleWidth: CGFloat = 97
        static let titleHeight: CGFloat = 20
        static let cashTagInset: CGFloat = 38
        static let titleVerticalOffset: CGFloat = 2
        static let horizontalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 12
        static let cornerRadius: CGFloat = 8
        static let verticalTextSpacing: CGFloat = 2
    }
}

// MARK: - View Model

@available(iOS 13.0, *)
extension CashAppPaymentMethodView {
    public class ViewModel: ObservableObject {
        @Published var size: SizingCategory
        @Published var cashTag: String
        @Published var cashTagFont: Font
        @Published var cashTagTextColor: Color?
        @Published var usePolychromeAsset: Bool
        @Published var label: CashAppPaymentMethodLabel
        init(
            size: SizingCategory,
            cashTag: String,
            cashTagFont: Font,
            cashTagTextColor: Color?,
            usePolychromeAsset: Bool,
            label: CashAppPaymentMethodLabel
        ) {
            self.size = size
            self.cashTag = cashTag
            self.cashTagFont = cashTagFont
            self.cashTagTextColor = cashTagTextColor
            self.usePolychromeAsset = usePolychromeAsset
            self.label = label
        }
    }
}

// MARK: - Preview

@available(iOS 13.0, *)
struct CashAppPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(CashAppPaymentMethodLabel.allCases, id: \.self) { label in
                CashAppPaymentMethodView(size: .large, cashTag: "$jack", label: label)
                    .padding()
                CashAppPaymentMethodView(size: .large, cashTag: "", label: label)
                    .padding()
                CashAppPaymentMethodView(size: .small, cashTag: "$jack", label: label)
                    .padding()
                CashAppPaymentMethodView(size: .large, cashTag: "$jack", usePolychromeAsset: true, label: label)
                    .padding()
            }
        }.background(Color.blue)
    }
}
