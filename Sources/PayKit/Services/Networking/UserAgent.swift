//
//  UserAgent.swift
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

import UIKit

/// A utility struct used in generating a user agent string for the customer's device.
/// An example is
///  "Mozilla/5.0 (iPhone7,2; CPU iPhone OS 10.0 like Mac OS X; en-us) PayKitVersion/2.1.5 com.squareup.PayKitDemo/1".
enum UserAgent {
    // MARK: - Private Static Properties

    static let unknownValue = "unknown"

    // MARK: - Public Static Properties

    static let userAgent: String = {
        func infoDictionaryString(forKey key: String) -> String {
            let bundleValue = Bundle.main.object(forInfoDictionaryKey: key) as? String
            return bundleValue ?? unknownValue
        }
        let appIdentifier = infoDictionaryString(forKey: kCFBundleIdentifierKey as String)
        let appVersion = infoDictionaryString(forKey: kCFBundleVersionKey as String)
        var payKitVersion = CashAppPay.version

        let model = UIDevice.current.deviceModel ?? unknownValue
        let language = Locale.current.languageCode?.lowercased() ?? unknownValue
        let country = Locale.current.regionCode?.lowercased() ?? unknownValue
        let osVersion = UIDevice.current.systemVersion

        return String(
            format: "Mozilla/5.0 (%@; CPU iPhone OS %@ like Mac OS X; %@-%@) PayKitVersion/%@ %@/%@",
            model,
            osVersion,
            language,
            country,
            payKitVersion,
            appIdentifier,
            appVersion
        )
    }()
}

// MARK: - UIDevice

extension UIDevice {
    // Returns the human readable version of the device being used
    var deviceModel: String? {
        if let sim = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return "Simulator(\(sim))"
        } else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let modelCode = withUnsafePointer(to: &systemInfo.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                     String(validatingUTF8: ptr)
                }
            }
            return modelCode
        }
    }
}
