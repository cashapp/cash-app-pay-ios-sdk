# PayKit for iOS

[![License](https://img.shields.io/badge/license-Apache2-green.svg?style=flat)](LICENSE) ![Swift](https://img.shields.io/badge/swift-5.0-brightgreen.svg) ![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg) ![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg) [![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

Pay Kit is an open source software framework that allows you to accept Cash App Pay in your App. The framework provides a modules that can be used out of the box where the customer will be redirected from your checkout experience to Cash App to approve the payment before being redirected back to your App. It is composed of two SPM packages which can each be imported separately.

* **`PayKit`:** This is the best place to start building your app. `PayKit` provides a protocol called `PayKitObserver` that receives updates from Pay Kit. Your checkout view controller can conform to this protocol, or you can create a dedicated observer class.

* **`PayKitUI`:** Provides the views used across the framework. The views are provided to the user to launch a Pay Kit payment and to present the Cashtag but do not prescribe how they must be used.

# Table of Contents
* [Requirements](#requirements)
* [Getting Started](#getting-started)
    * [SPM](#spm)
    * [Cocoapods](#cocoapods)
* [`PayKit`](#paykit)
    * [`PayKitObserver`](#pay-kit-observer)
    * [Implement URL handling](#implement-url-handling)
    * [Instantiate PayKit](#instantiate-paykit)
    * [Create a Customer Request](#create-a-customer-request)
    * [Authorize the Customer Request](#authorize-the-customer-request)
    * [Pass Grants to the Backend and Create Payment](#grants)
* [`PayKitUI`](#paykitui)
    * [`CashAppPayButton`](#cash-app-pay-button)
    * [`CashAppPaymentMethod`](#cash-app-payment-method)
* [Getting Help](#getting-help)
* [License](#license)

# Requirements <a name="requirements"></a>

The primary `PayKit` framework codebase supports iOS and requires Xcode 12.0 or newer. The `PayKit` framework has a Base SDK version of 13.0.

# Getting Started <a name="getting-started"></a>

* [Website](https://developers.cash.app/docs/api/welcome)
* [Documentation](https://developers.cash.app/docs/api/technical-documentation/sdks/pay-kit/ios-getting-started)

### Installation (Option One): SPM <a name="spm"></a>

You can install Pay Kit via SPM. Create a new Xcode project and navigate to `File > Swift Packages > Add Package Dependency`. Enter the url `https://github.com/cashapp/cash-app-pay-ios-sdk` and tap **Next**. Choose the `main` branch, and on the next screen, check off the packages as needed.

### Installation (Option Two): Cocoapods  <a name="cocoapods"></a>

Add Cocoapods to your to your project. Open the `Podfile` and add `pod 'CashAppPayKit'` and/or `pod 'CashAppPayKitUI'` and save your changes. Run `pod update` and Pay Kit will now be included through Cocoapods

# PayKit <a name="paykit"></a>

### `PayKitObserver` <a name="pay-kit-observer"></a>

The `PayKitObserver` protocol contains only one method:

```swift
func stateDidChange(to state: CashAppPaySDKState) {
    // handle state changes
}
```

Your implementation should switch on the state parameter and handle the appropriate state changes. Some of these possible states are for information only, but most drive the logic of your integration. The most critical states to handle are listed in the table below:

|State|Description|
|--|---|
|`ReadyToAuthorize` | Show a Cash App Pay button in your UI and call `authorizeCustomerRequest()` when it is tapped |
| `Approved` |Grants are ready for your backend to use to create a payment|
|`Declined`|Customer has declined the Cash App Pay authorization and must start the flow over or choose a new payment method|
|**The error states**| |
|`.integrationError` |A fixable bug in your integration|
|`.apiError` | A degradation of Cash App Pay server APIs. Your app should temporarily hide Cash App Pay functionality |
|`.unexpectedError` | A bug outside the normal flow. Report this bug (and what caused it) to Cash App Developer Support |


### Implement URL handling <a name="implement-url-handling"></a>

To use Pay Kit iOS, Cash App must be able to call a URL that will redirect back to your app. The simplest way to accomplish this is via [Custom URL Schemes](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app), but if your app supports [Universal Links](https://developer.apple.com/ios/universal-links/) you ca use those URLs as well.

Choose a unique scheme for your application and register it in Xcode from the Info tab of your application’s target.

You will pass a URL that uses this scheme (or a Universal Link your app handles) into the `createCustomerRequest()` method that starts the authorization process.

When your app is called back by Cash App, simply post the `PayKit.RedirectNotification` from your `AppDelegate` or `SceneDelegate`, and the SDK will handle the rest:

```swift
import UIKit
import PayKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
                if let url = URLContexts.first?.url {
                    NotificationCenter.default.post(
                        name: PayKit.RedirectNotification,
                        object: nil,
                        userInfo: [UIApplication.LaunchOptionsKey.url : url]
                    )
                }
            }
        }
}
```

### Instantiate `PayKit` <a name="instantiate-paykit"></a>

When you are ready to authorize a payment using Cash App Pay,

1. Instantiate the SDK with your Client ID 
2. The SDK defaults to point to the `production` endpoint; for development, set the endpoint to `sandbox`
3. Add your observer to the SDK

For example, from your checkout view controller that implements the `PayKitObserver` protocol, you can instantiate the SDK to be:

```swift
private let sandboxClientID = "YOUR_CLIENT_ID"
private lazy var sdk: PayKit = {
    let sdk = PayKit(clientID: sandboxClientID, endpoint: .sandbox)
    sdk.addObserver(self)
    return sdk
}()
```

### Create a Customer Request <a name="create-a-customer-request"></a>

You can create a customer request as soon as you know the amount you’d like to charge or if you'd like to create an on-file payment request. You must create this request as soon as your checkout view controller loads, so that your customer can authorize the request without any delay.

To charge $5.00, your `createCustomerRequest` call might look like this:

```swift
private let sandboxBrandID = "YOUR_BRAND_ID"

override func viewDidLoad() {
    super.viewDidLoad()
    // load view hierarchy
    sdk.createCustomerRequest(
        params: CreateCustomerRequestParams(
            actions: [
                .oneTimePayment(
                    scopeID: brandID,
                    money: Money(amount: 500, currency: .USD)
                )
            ],
            channel: .IN_APP,
            redirectURL: URL(string: "tipmycap://callback")!,
            referenceID: nil,
            metadata: nil
        )
    )
}
```

Your Observer’s state will change to `.creatingCustomerRequest`, then `.readyToAuthorize` with the created `CustomerRequest` struct as an associated value.

### Authorize the Customer Request <a name="authorize-the-customer-request"></a>

Once the SDK is in the `.readyToAuthorize` state, you can store the associated `CustomerRequest` and display a Cash App Pay button. When the customer taps the button, you can authorize the customer request.

**Example**

```swift
@objc func cashAppPayButtonTapped() {
   sdk.authorizeCustomerRequest(request)
}
```

Your app will redirect to Cash App for authorization. When authorization is completed, your redirect URL will be called, the `RedirectNotification` will post. The SDK will fetch your authorized request and return it to your Observer, as part of the change to the `.approved` state.

### Pass Grants to the Backend and Create Payment <a name="grants"></a>

The approved `CustomerRequest` will have `Grants` associated with it that can be used with Cash App’s [Create Payment](https://developers.cash.app/docs/api/network-api/operations/create-a-payment) API. Pass those Grants to your backend and call the `CreatePayment` API as a server-to-server call to complete your payment.

# `PayKitUI` <a name="paykitui"></a>

`PayKitUI` provides an unmanaged `CashAppPayButton` and a `CashAppPaymentMethod` view in both **UIKit** and **SwiftUI**.

All of the views accept a `SizingCategory` to dictate the preferred size of the view within your app. They also support light/dark themes by default.

We want you to use these views as-is, without any modification.

### `CashAppPayButton` <a name="cash-app-pay-button"></a>

The following is an example of the `CashAppPayButton`:

<img width="368" alt="image" src="https://user-images.githubusercontent.com/8743061/216639753-159f2b3e-21be-4113-8a92-fd77e93acd12.png">

You can instantiate the button as follows:

```swift
let button = CashAppPayButton(size: .small, onClickHandler: {})
```

### `CashAppPaymentMethod` <a name="cash-app-payment-method"></a>

The following is an example of `CashAppPaymentMethod`:

<img width="170" alt="image" src="https://user-images.githubusercontent.com/8743061/216639415-49591e1e-046e-49a0-b480-b6249394254d.png">

You can instatiate the `CashAppPaymentMethod` as follows:

```swift
let paymentMethod = CashAppPaymentMethod(size: .small)
paymentMethod.cashTag = "$jack"
```

# Getting Help <a name="getting-help"></a>

GitHub is our primary forum for Pay Kit. To get help, open **Issues** about questions, problems, or ideas.

# License <a name="license"></a>

This project is made available under the terms of a Apache 2.0 license. See the [LICENSE](LICENSE) file.

    Copyright 2023 Square, Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
