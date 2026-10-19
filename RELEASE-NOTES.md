## PayKit Next Release Notes (unreleased)

- **`CashAppPayButton` labels and styles**

    `CashAppPayButton` and `CashAppPayButtonView` have a new initializer, `init(label:style:size:onClickHandler:)` (`init(label:style:size:isEnabled:onClickHandler:)` for `CashAppPayButtonView`). Both new parameters are optional.

    `label` picks the call to action:

    - `.cashAppPay`: the Cash App icon and "Cash App Pay". This is the default.
    - `.cashApp`: the Cash App icon and "Cash App".
    - `.pay`: "Pay with Cash App".
    - `.buy`: "Buy with Cash App", for example for a "Buy now" button on a product page.
    - `.cashOut`: "Cash out with Cash App".
    - `.checkout`: "Checkout with Cash App", for example on a checkout screen.
    - `.continue`: "Continue with Cash App".
    - `.connect`: "Connect to Cash App", for linking the customer's Cash App account, such as saving it for future payments.

    `style` picks the color variant:

    - `.black`: white label and green Cash App icon on a black background.
    - `.white`: black label and green Cash App icon on a white background with a thin black outline.
    - `.monochromeBlack`: white label and icon on a black background.
    - `.monochromeWhite`: black label and icon on a white background with a thin black outline.
    - `.green`: black label and icon on a Cash App green background.
    - `.automatic`: `.black` in light mode and `.white` in dark mode. This is the default.
    - `.monochromeAutomatic`: `.monochromeBlack` in light mode and `.monochromeWhite` in dark mode.

    Pick a fixed style, such as `.black` or `.green`, for a button that doesn't change with the system appearance.

- **`usePolychromeAsset` on the button is deprecated**

    The initializers that take `usePolychromeAsset` still compile and work, but are deprecated in favor of `style`:

    - `style: .green` replaces `usePolychromeAsset: true`.
    - `style: .monochromeAutomatic` matches the previous default look (`usePolychromeAsset: false`).

    Existing calls that don't pass `usePolychromeAsset`, such as `CashAppPayButton(size: .small, onClickHandler: {})`, now use the new initializer.

- **New button artwork**

    Every button now shows new artwork. Because the new initializer defaults to `style: .automatic`, buttons created without `usePolychromeAsset` now show the green Cash App icon on a black background in light mode and on a white background in dark mode. Pass `style: .monochromeAutomatic` to keep the previous monochrome look.

- **`CashAppPaymentMethod` label option**

    `CashAppPaymentMethod` has a new initializer, `init(size:cashTag:usePolychromeAsset:label:)`, and a `label` property. `CashAppPaymentMethodView` has a matching `init(size:cashTag:cashTagFont:cashTagTextColor:usePolychromeAsset:label:)`.

    `label` picks the logo shown on the view:

    - `.cashAppPay`: the "Cash App Pay" logo. This is the default, and matches 2.0.0.
    - `.cashApp`: the "Cash App" logo. With `usePolychromeAsset: true`, it shows the green Cash App icon on a black background in both light and dark mode.

    Existing initializers are unchanged and keep showing the "Cash App Pay" logo.

- **`CashAppPaymentMethod` cashtag on green**

    With `usePolychromeAsset: true` in dark mode, the default Cash Tag color on the green background is now near-black, like the logo, instead of white. A custom `cashTagTextColor` or `setCashTagTextColor(_:)` color is used as set.

    `CashAppPaymentMethodView`'s `cashTagTextColor` parameter is now optional and defaults to `nil`, which selects the default color. Existing code compiles unchanged. Passing `CashAppPaymentMethodView.Constants.cashTagTextColor` now uses that color as set, including on the green background.

## PayKit 2.0.0 Release Notes

Pay Kit 2.0.0 supports iOS 12 and later.

Pay Kit 2.0.0 includes customer profile sharing and a source compatibility change.

- **Customer profile sharing**

    Adds support for customer profile sharing. This adds `CUSTOMER_PROFILE_SHARING` to the public `PaymentType` enum. Apps with exhaustive switches over `PaymentType` must handle the new case.

## Paykit 1.0.0 Release Notes

Pay Kit 1.0.0 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 1.0.0 includes the following new features and enhancements.

- **PayKit Update**

    Addition of a new CustomerRequest payment action, payment type of `ON_FILE_PAYOUT`. This payment type enables merchants to payout customers.

## Paykit 0.6.3 Release Notes

Pay Kit 0.6.3 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.6.3 includes the following new features and enhancements.

- **PayKitUI Update**

    This is a complete UI Update to button and payment method styles to coincide with Afterpay + Cash App brand convergence UI.  An additional parameter called `usePolychromeAsset` will toggle between the two convergence UI styles and will default to false.  Since this is not a breaking API change, it's recommended to view and select which asset type (`usePolychromeAsset`) to use. See `ComponentsViewController` to view all variations.  

## PayKit 0.6.2 Release Notes

Pay Kit 0.6.2 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.6.2 includes the following new features and enhancements.

- **Privacy Manifest**

   PayKit and PayKitUI now each contain a Privacy Manifest.

## PayKit 0.6.1 Release Notes

Pay Kit 0.6.1 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.6.1 includes the following new features and enhancements.

- **Objective-C Improvements**

   Fixed a crash in the Objective-C wrapper where calls to `retrieveCustomerRequest` would crash if an error was encountered.

## PayKit 0.6.0 Release Notes

Pay Kit 0.6.0 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.6.0 includes the following new features and enhancements.

- **PayKit Supports Objective-C**

   PayKit now provides Objective-C bindings.

## PayKit 0.5.1 Release Notes

Pay Kit 0.5.1 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.5.1 includes the following new features and enhancements.

- **Dropped Support for iOS 11 in PayKitUI**

   Increased the minimum supported iOS version to 12.

- **`PayKitDemo` Demo**

   The *`PayKitDemo` App* includes a button to dismiss the keyboard and better support for light and dark themes.

## PayKit 0.5.0 Release Notes

Pay Kit 0.5.0 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 12.0.

Pay Kit 0.5.0 includes the following new features and enhancements.

- **Dropped Support for iOS 11**

   Increased the minimum supported iOS version to 12.

## PayKit 0.4.1 Release Notes

Pay Kit 0.4.1 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.4.1 includes the following new features and enhancements.

- **Redacting PII**

   Added redactions for personally identifiable information.

## PayKit 0.4.0 Release Notes

Pay Kit 0.4.0 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.4.0 includes the following new features and enhancements.

- **Adds `refreshing` to `CashAppPayState`**

   When calling `authorizeCustomerRequest()` for a CustomerRequest with expired `AuthFlowTriggers` the state machine refreshes the CustomerRequest before redirecting.

   This is a breaking change and clients updating from an older version should show a loading state here.

## PayKit 0.3.3 Release Notes

Pay Kit 0.3.3 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.3.3 includes the following new features and enhancements.

- **`retrieveCustomerRequest`**

   Adds a method to retrieve an existing CustomerRequest by ID.

## PayKit 0.3.2 Release Notes

Pay Kit 0.3.2 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.3.2 includes the following new features and enhancements.

- **Cocoapods**

   `PayKit` and `PayKitUI` support iOS 11 when imported through Cocoapods.

## PayKit 0.3.1 Release Notes

Pay Kit 0.3.1 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.3.1 includes the following new features and enhancements.

- **`PayKitDemo` Demo**

   The *`PayKitDemo` App* now includes a toggle to test in the staging environment.

## Pay Kit 0.3.0 Release Notes
Pay Kit 0.3.0 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.3.0 includes the following new features and enhancements.

- **Name changes**

   `PayKit` class has been renamed to `CashAppPay`.

## Pay Kit 0.2.0 Release Notes

Pay Kit 0.2.0 supports iOS and requires Xcode 9 or later. The minimum supported Base SDK is 11.0.

Pay Kit 0.2.0 includes the following new features and enhancements.

- **Pay Kit Compiles in iOS 11**

   Pay Kit now supports a minimum base SDK version of 11.0 however `PayKitUI` still requires SDK version 13.0.

- **`CashAppPayButton` Disabled State**

   The `CashAppPayButton` now supports a disabled state when the button is not tappable.

## Pay Kit 0.1.0 Release Notes

Pay Kit 0.1.0 supports iOS and requires Xcode 11 or later. The minimum supported Base SDK is 13.0.

Pay Kit 0.1.0 includes the following new features and enhancements.

- **Pay Kit**

   Pay Kit allows you to accept Cash App Pay in your App.

- **Pay Kit UI**

  `PayKitUI` contains views provided the user to launch a Pay Kit payment and to present the Cashtag.

- **Test App**

  The `PayKitDemo` App (`PayKitDemo` project in the Pay Kit workspace) serves as an application to test different modules and features from
      the Pay Kit framework.
