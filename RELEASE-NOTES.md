## PayKit Next Release Notes (unreleased)

- **Breaking: `CashAppPayButton` call to action**

    `CashAppPayButton` and `CashAppPayButtonView` now show "Pay with Cash App", "Cash out with Cash App", or "Connect Cash App" instead of "Cash App Pay". Both now take a required `label`, and use `CashAppPayButtonLabel(actions:)` to pick it from a customer request's actions: `.payWith` when every action is a payment, `.cashOutWith` when every action is a payout, and `.connect` otherwise.

    To override the automatic label, pass `.checkoutWith` ("Checkout with Cash App") or `.continueWith` ("Continue with Cash App") as `label`. `CashAppPayButtonLabel(actions:)` never returns these two.

    The `usePolychromeAsset` parameter on the button is replaced by `style`. The default, `.automatic`, follows the system appearance: black in light mode and white in dark mode. Pass `.black` or `.white` for a button that doesn't change with the system appearance.

    `PayKitUI` now depends on `PayKit`.

- **`CashAppPaymentMethod` shows the Cash App logo**

    `CashAppPaymentMethod` and `CashAppPaymentMethodView` now show the "Cash App" logo instead of "Cash App Pay". Their API and layout are unchanged.

    With `usePolychromeAsset: true`, the view now shows the green Cash App icon on a black background in both light and dark mode. Dark mode previously switched to a green background.

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
