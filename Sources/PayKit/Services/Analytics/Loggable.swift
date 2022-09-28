//
//  Loggable.swift
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

enum LoggableType: CustomStringConvertible, Equatable {
    case string(String)
    case int(Int)
    case uint(UInt)
    case bool(Bool)

    var object: Any {
        switch self {
        case .string(let string):
            return string
        case .int(let int):
            return int
        case .uint(let uint):
            return uint
        case .bool(let bool):
            return bool
        }
    }

    // MARK: - CustomStringConvertible

    var description: String {
        switch self {
        case .string(let string):
            return string.description
        case .int(let int):
            return int.description
        case .uint(let uint):
            return uint.description
        case .bool(let bool):
            return bool.description
        }
    }
}

protocol Loggable {
    var loggableDescription: LoggableType { get }
}

extension Int: Loggable {
    var loggableDescription: LoggableType {
        .int(self)
    }
}

extension Bool: Loggable {
    var loggableDescription: LoggableType {
        .bool(self)
    }
}

extension String: Loggable {
    var loggableDescription: LoggableType {
        .string(self)
    }
}

extension URL: Loggable {
    var loggableDescription: LoggableType {
        .string(absoluteString)
    }
}

extension Date: Loggable {
    var loggableDescription: LoggableType {
        return .uint(microsecondsSince1970)
    }
}

// MARK: - Collections

extension Array: Loggable where Element: Loggable {
    var loggableDescription: LoggableType {
        let listString = map {"\"" + $0.loggableDescription.description + "\""}.joined(separator: ",")
        return .string("[\(listString)]")
    }
}

extension Dictionary: Loggable where Key: Comparable & Loggable, Value: Loggable {
    var loggableDescription: LoggableType {
        // Sort the keys so that the result is deterministic.
        let pairListString = sortedByKey(with: <)
            .map {(key, val) in "\"\(key.loggableDescription.description)\":\"\(val.loggableDescription.description)\""}
            .joined(separator: ",")

        return .string("{\(pairListString)}")
    }

    private func sortedByKey(with comparator: (Key, Key) throws -> Bool) rethrows -> [(key: Key, value: Value)] {
        return try sorted(by: { (p1, p2) in try comparator(p1.key, p2.key) })
    }
}

// MARK: - PayKit Loggable Extensions

extension Money: Loggable {
    static let encoder: JSONEncoder = .eventStream2Encoder()

    var loggableDescription: LoggableType {
        guard let data = try? Self.encoder.encode(self),
                let value = String(data: data, encoding: .utf8) else {
            return .string("")
        }
        return .string(value)
    }
}

extension PaymentAction: Loggable {
    static let encoder: JSONEncoder = .eventStream2Encoder()

    var loggableDescription: LoggableType {
        guard let data = try? Self.encoder.encode(self),
                let value = String(data: data, encoding: .utf8) else {
            return .string("")
        }
        return .string(value)
    }
}

extension CustomerRequest.Grant: Loggable {
    static let encoder: JSONEncoder = .eventStream2Encoder()

    var loggableDescription: LoggableType {
        guard let data = try? Self.encoder.encode(self),
                let value = String(data: data, encoding: .utf8) else {
            return .string("")
        }
        return .string(value)
    }
}
