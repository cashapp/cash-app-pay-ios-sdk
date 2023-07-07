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

// MARK: - Redactions

extension Loggable {
    var redacted: String { "FILTERED" }
}

struct LoggablePaymentAction: Encodable, Equatable, Loggable {
    let type: PaymentType
    let scopeID: String
    let money: Money?
    let accountReferenceID: String?
    let clearing: Bool

    init(paymentAction: PaymentAction) {
        self.type = paymentAction.type
        self.scopeID = paymentAction.scopeID
        self.money = paymentAction.money
        self.accountReferenceID = paymentAction.accountReferenceID?.redacted
        self.clearing = paymentAction.clearing
    }

    enum CodingKeys: String, CodingKey {
        case type, scopeID = "scopeId", amount, currency, accountReferenceID = "accountReferenceId"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(scopeID, forKey: .scopeID)
        switch type {
        case .ONE_TIME_PAYMENT:
            if clearing {
                try container.encode(money?.amount, forKey: .amount)
                try container.encode(money?.currency, forKey: .currency)
            } else {
                try container.encodeIfPresent(money?.amount, forKey: .amount)
                try container.encodeIfPresent(money?.currency, forKey: .currency)
            }

        case .ON_FILE_PAYMENT:
            if clearing {
                try container.encode(accountReferenceID, forKey: .accountReferenceID)
            } else {
                try container.encodeIfPresent(accountReferenceID, forKey: .accountReferenceID)
            }
        }
    }

    // MARK: - Loggable

    private static let encoder: JSONEncoder = .eventStream2Encoder()

    var loggableDescription: LoggableType {
        guard let data = try? Self.encoder.encode(self),
                let value = String(data: data, encoding: .utf8) else {
            return .string("")
        }
        return .string(value)
    }
}

struct LoggableGrant: Encodable, Equatable, Loggable {
    let id: String
    let customerID: String
    let action: LoggablePaymentAction
    let status: CustomerRequest.Grant.Status
    let type: CustomerRequest.Grant.GrantType
    let channel: Channel
    let createdAt: Date
    let updatedAt: Date
    let expiresAt: Date?

    init(grant: CustomerRequest.Grant) {
        self.id = grant.id
        self.customerID = grant.customerID
        self.action = LoggablePaymentAction(paymentAction: grant.action)
        self.status = grant.status
        self.type = grant.type
        self.channel = grant.channel
        self.createdAt = grant.createdAt
        self.updatedAt = grant.updatedAt
        self.expiresAt = grant.expiresAt
    }

    enum CodingKeys: String, CodingKey {
        case id, customerID = "customerId", action, status, type, channel, createdAt, updatedAt, expiresAt
    }

    // MARK: - Loggable

    private static let encoder: JSONEncoder = .eventStream2Encoder()

    var loggableDescription: LoggableType {
        guard let data = try? Self.encoder.encode(self),
                let value = String(data: data, encoding: .utf8) else {
            return .string("")
        }
        return .string(value)
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
