//
//  JSONEncoder+Analytics.swift
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

// MARK: - JSONEncoder

extension JSONEncoder {
    static func eventStream2Encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .microsecondsSince1970
        encoder.outputFormatting = .sortedKeys
        return encoder
    }
}

extension JSONEncoder.DateEncodingStrategy {
    // Encode the data to ms rounding to remove fractions
    static let microsecondsSince1970 = custom { date, encoder in
        var container = encoder.singleValueContainer()
        try container.encode(date.microsecondsSince1970)
    }
}

extension Date {
    var microsecondsSince1970: UInt {
        UInt((timeIntervalSince1970 * 1_000_000).rounded())
    }
}
