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
     Initializes a button with the Cash App Logo and name.

     - Parameters:
     - size: The size of the button. Defaults to `large`.
     - isEnabled: True if the button is enabled.
     - onClickHandler: The handler called when the button is tapped.
     */
    public init(size: SizingCategory = .large, isEnabled: Bool = true, onClickHandler: @escaping () -> Void) {
        self.viewModel = ViewModel(size: size, isEnabled: isEnabled)
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
            Asset.Images.lightLogo.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: minImageWidth, height: iconHeight)
                .padding(
                    EdgeInsets(
                        top: buttonInset,
                        leading: horizontalPadding,
                        bottom: .zero,
                        trailing: horizontalPadding
                    )
                )
                .opacity(tileImageOpacity)
        }.disabled(!viewModel.isEnabled)
            .frame(
                minWidth: minButtonWidth,
                maxWidth: .infinity,
                minHeight: fixedHeight,
                maxHeight: fixedHeight
            )
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(buttonBackgroundColor)
            )
    }

    private var iconHeight: CGFloat {
        switch viewModel.size {
        case .small: return Constants.iconSizeSmall
        case .large: return Constants.iconSizeLarge
        }
    }

    private var horizontalPadding: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallHorizontalPadding
        case .large: return Constants.largeHorizontalPadding
        }
    }

    private var minButtonWidth: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallButtonWidth
        case .large: return Constants.largeButtonWidth
        }
    }

    private var minImageWidth: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallImageWidth
        case .large: return Constants.largeImageWidth
        }
    }

    private var fixedHeight: CGFloat {
        switch viewModel.size {
        case .small: return Constants.smallHeight
        case .large: return Constants.largeHeight
        }
    }

    private var buttonInset: CGFloat {
        switch viewModel.size {
        case .small: return Constants.iconTopPaddingSmall
        case .large: return Constants.iconTopPaddingLarge
        }
    }

    private var buttonBackgroundColor: Color {
        if viewModel.isEnabled {
            return Asset.Colors.surfacePrimary.swiftUIColor
       } else {
           return Asset.Colors.surfacePrimaryDisabled.swiftUIColor
       }
    }

    private var tileImageOpacity: CGFloat {
        if viewModel.isEnabled {
            return Constants.opaque
        } else {
            return Constants.disabledOpacity
        }
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 150

        static let largeHeight: CGFloat = 48
        static let smallHeight: CGFloat = 30

        static let largeImageWidth: CGFloat = 185
        static let smallImageWidth: CGFloat = 122

        static let largeButtonWidth: CGFloat = 210
        static let smallButtonWidth: CGFloat = 145

        static let smallHorizontalPadding: CGFloat = 11
        static let largeHorizontalPadding: CGFloat = 21

        static let buttonPadding: CGFloat = 10

        static let iconSizeSmall: CGFloat = 16
        static let iconSizeLarge: CGFloat = 20

        static let iconTitleSpacing: CGFloat = 4

        static let iconTopPaddingLarge: CGFloat = 6
        static let iconTopPaddingSmall: CGFloat = 4

        static let opaque: CGFloat = 1
        static let disabledOpacity: CGFloat = 0.4
    }
}

// MARK: - View Model

@available(iOS 13.0, *)
extension CashAppPayButtonView {
    public class ViewModel: ObservableObject {
        @Published var size: SizingCategory
        @Published var isEnabled: Bool

        init(size: SizingCategory, isEnabled: Bool) {
            self.size = size
            self.isEnabled = isEnabled
        }
    }
}

@available(iOS 13.0, *)
struct CashButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CashAppPayButtonView(isEnabled: false, onClickHandler: {})
            HStack {
                Spacer().frame(width: .infinity)
                CashAppPayButtonView(size: .large, onClickHandler: {})
                Spacer().frame(width: .infinity)
            }
            HStack {
                Spacer().frame(width: .infinity)
                CashAppPayButtonView(size: .small, onClickHandler: {})
                Spacer().frame(width: .infinity)
            }
            CashAppPayButtonView(size: .large, onClickHandler: {})
            CashAppPayButtonView(size: .small, onClickHandler: {})
        }.background(Color.blue)
    }
}
