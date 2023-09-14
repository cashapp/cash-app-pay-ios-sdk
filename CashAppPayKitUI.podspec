Pod::Spec.new do |s|
    s.name         = 'CashAppPayKitUI'
    s.version      = "0.5.0"
    s.summary      = 'UI components for the PayKit iOS SDK'
    s.homepage     = 'https://github.com/cashapp/cash-app-pay-ios-sdk'
    s.license      = 'Apache License, Version 2.0'
    s.author       = 'Cash App'
    s.source       = { :git => 'https://github.com/cashapp/cash-app-pay-ios-sdk.git', :tag => "v#{s.version}" }
    s.module_name = 'PayKitUI'

    ios_deployment_target = '12.0'

    s.swift_version = ['5.0']
    s.ios.deployment_target = ios_deployment_target

    s.resources = "Sources/PayKitUI/Shared/Assets/Resources/**/**.xcassets"
    s.source_files = 'Sources/PayKitUI/**/**.swift'

   s.test_spec 'Tests' do |test_spec|
       test_spec.dependency 'SnapshotTesting', '~> 1.9'
       test_spec.requires_app_host = true
       test_spec.source_files = 'Tests/PayKitUITests/**/*.swift'

       test_spec.ios.resource_bundle = {
            'SnapshotTestImages' => 'Tests/PayKitUITests/*'
       }
   end
end

