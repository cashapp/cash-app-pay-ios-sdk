Pod::Spec.new do |s|
    s.name         = 'CashAppPayKit'
    s.version      = '0.3.0'
    s.summary      = 'PayKit iOS SDK'
    s.homepage     = 'https://github.com/cashapp/cash-app-pay-ios-sdk'
    s.license      = 'Apache License, Version 2.0'
    s.author       = 'Cash App'
    s.source       = { :git => 'https://github.com/cashapp/cash-app-pay-ios-sdk.git', :tag => "v#{s.version}" }
    s.module_name = 'PayKit'

    s.swift_version = ['5.0']
    s.ios.deployment_target = '13.0'

    s.source_files = 'Sources/PayKit/**/*.swift'

    s.test_spec 'Tests' do |test_spec|
        test_spec.source_files = 'Tests/PayKitTests/**/*.swift'
        test_spec.framework = 'XCTest'
        test_spec.library = 'swiftos'
        test_spec.requires_app_host = true
        test_spec.resources = 'Tests/PayKitTests/Resources/Fixtures/**/*.json'

        test_spec.resource_bundles = {
            "PayKitTestFixtures" => [
                "Tests/PayKitTests/Resources/Fixtures/**/*.json"
            ]
        }
    end
end