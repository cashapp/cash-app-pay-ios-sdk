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
     - usePolychromeAsset: Toggle usage of polychrome UI
     */
    public init(
        size: SizingCategory = .large,
        isEnabled: Bool = true,
        onClickHandler: @escaping () -> Void,
        usePolychromeAsset: Bool = false
    ) {
        self.viewModel = ViewModel(size: size, isEnabled: isEnabled, usePolychromeAsset: usePolychromeAsset)
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
                    .fill(buttonBackgroundColor)
                currentAsset
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(
                        EdgeInsets(
                            top: .zero,
                            leading: horizontalPadding,
                            bottom: .zero,
                            trailing: horizontalPadding
                        )
                    )
                    .frame(width: minImageWidth, height: iconHeight)
            }
        }
        .opacity(tileImageOpacity)
        .disabled(!viewModel.isEnabled)
            .frame(
                minWidth: minButtonWidth,
                maxWidth: .infinity,
                minHeight: fixedHeight,
                maxHeight: fixedHeight
            )
    }

    private var currentAsset: SwiftUI.Image {
        viewModel.usePolychromeAsset ?
            Asset.Images.polyChromeLogo.swiftUIImage : Asset.Images.monoChromeLogo.swiftUIImage
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
        return
            switch (viewModel.isEnabled, viewModel.usePolychromeAsset) {
            case (true, true):
                Asset.Colors.polyChrome.swiftUIColor
            case (_, false):
                Asset.Colors.surfacePrimary.swiftUIColor
            case (false, true):
                Asset.Colors.polyChrome.swiftUIColor
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
        static let cornerRadius: CGFloat = 8

        static let largeHeight: CGFloat = 48
        static let smallHeight: CGFloat = 30

        static let largeImageWidth: CGFloat = 135
        static let smallImageWidth: CGFloat = 89

        static let largeButtonWidth: CGFloat = 320
        static let smallButtonWidth: CGFloat = 221

        static let smallHorizontalPadding: CGFloat = 49
        static let largeHorizontalPadding: CGFloat = 92.685

        static let buttonPadding: CGFloat = 10

        static let iconSizeSmall: CGFloat = 19
        static let iconSizeLarge: CGFloat = 24

        static let iconTitleSpacing: CGFloat = 4

        static let iconTopPaddingLarge: CGFloat = 12
        static let iconTopPaddingSmall: CGFloat = 8

        static let opaque: CGFloat = 1
        static let disabledOpacity: CGFloat = 0.3
    }
}

// MARK: - View Model

@available(iOS 13.0, *)
extension CashAppPayButtonView {
    public class ViewModel: ObservableObject {
        @Published var size: SizingCategory
        @Published var isEnabled: Bool
        @Published var usePolychromeAsset: Bool
        init(size: SizingCategory, isEnabled: Bool, usePolychromeAsset: Bool) {
            self.size = size
            self.isEnabled = isEnabled
            self.usePolychromeAsset = usePolychromeAsset
        }
    }
}

@available(iOS 13.0, *)
struct CashButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CashAppPayButtonView(isEnabled: false, onClickHandler: {}, usePolychromeAsset: false)
            HStack {
                Spacer().frame(width: .infinity)
                CashAppPayButtonView(size: .large, onClickHandler: {}, usePolychromeAsset: false)
                Spacer().frame(width: .infinity)
            }
            HStack {
                Spacer().frame(width: .infinity)
                CashAppPayButtonView(size: .small, onClickHandler: {}, usePolychromeAsset: false)
                Spacer().frame(width: .infinity)
            }
            CashAppPayButtonView(size: .large, onClickHandler: {}, usePolychromeAsset: false)
            CashAppPayButtonView(size: .small, onClickHandler: {}, usePolychromeAsset: false)
        }.background(Color.blue)
    }
}
