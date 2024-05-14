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
