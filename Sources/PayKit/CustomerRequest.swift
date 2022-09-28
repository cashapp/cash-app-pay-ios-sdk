//
//  CustomerRequest.swift
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

/// The parameters passed to the CreateCustomerRequest endpoint
public struct CreateCustomerRequestParams: Codable, Equatable {
    public let actions: [PaymentAction]
    public let channel: Channel
    public let redirectURL: URL
    public let referenceID: String?
    public let metadata: [String: String]?

    public init(
        actions: [PaymentAction],
        channel: Channel = .IN_APP,
        redirectURL: URL,
        referenceID: String?,
        metadata: [String: String]?
    ) {
        self.actions = actions
        self.channel = channel
        self.redirectURL = redirectURL
        self.referenceID = referenceID
        self.metadata = metadata
    }

    enum CodingKeys: String, CodingKey {
        case actions, channel, redirectURL = "redirectUrl", referenceID = "referenceId", metadata
    }
}

/// The parameters passed to the UpdateCustomerRequest endpoint
public struct UpdateCustomerRequestParams: Equatable, Decodable {
    public let actions: [PaymentAction]
    public let referenceID: String?
    public let metadata: [String: String]?

    public init(
        actions: [PaymentAction],
        referenceID: String?,
        metadata: [String: String]?
    ) {
        let clearingActions: [PaymentAction] = actions.map {
            var action = $0
            action.clearing = true
            return action
        }
        self.actions = clearingActions
        self.referenceID = referenceID
        self.metadata = metadata
    }

    enum CodingKeys: String, CodingKey {
        case actions, referenceID = "referenceId", metadata
    }
}

// Manually encode, to force encoding `null`s for nil values
extension UpdateCustomerRequestParams: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actions, forKey: .actions)
        try container.encode(referenceID, forKey: .referenceID)
        try container.encode(metadata, forKey: .metadata)
    }
}

/// The CustomerRequest object returned by the server.
public struct CustomerRequest: Codable, Equatable {
    public let id: String

    public enum Status: String, Codable {
        case PENDING
        case PROCESSING
        case APPROVED
        case DECLINED
    }
    public let status: Status

    public let actions: [PaymentAction]

    public struct AuthFlowTriggers: Codable, Equatable {
        public let qrCodeImageURL: URL
        public let qrCodeSVGURL: URL
        public let mobileURL: URL
        public let refreshesAt: Date

        enum CodingKeys: String, CodingKey {
            case qrCodeImageURL = "qrCodeImageUrl", qrCodeSVGURL = "qrCodeSvgUrl", mobileURL = "mobileUrl", refreshesAt
        }
    }
    public let authFlowTriggers: AuthFlowTriggers?

    public let redirectURL: URL?
    public let createdAt: Date
    public let updatedAt: Date
    public let expiresAt: Date

    public struct Origin: Codable, Equatable {
        public enum `Type`: String, Codable {
            case DIRECT
            case REQUEST_INITIATOR
        }

        public let type: `Type`
        public let id: String?
    }
    public let origin: Origin?

    public let channel: Channel

    public struct Grant: Codable, Equatable {
        public let id: String
        public let customerID: String
        public let action: PaymentAction

        public enum Status: String, Codable, Equatable {
            case ACTIVE
            case EXPIRED
            case CONSUMED
            case REVOKED
        }
        public let status: Status

        public enum GrantType: String, Codable, Equatable {
            case ONE_TIME
            case EXTENDED
        }
        public let type: GrantType

        public let channel: Channel
        public let createdAt: Date
        public let updatedAt: Date
        public let expiresAt: Date?

        enum CodingKeys: String, CodingKey {
            case id, customerID = "customerId", action, status, type, channel, createdAt, updatedAt, expiresAt
        }
    }
    public let grants: [Grant]?

    public let referenceID: String?

    public struct RequesterProfile: Codable, Equatable {
        public let name: String
        public let logoURL: URL
        enum CodingKeys: String, CodingKey {
            case name, logoURL = "logoUrl"
        }
    }
    public let requesterProfile: RequesterProfile?

    public struct CustomerProfile: Codable, Equatable {
        public let id: String
        public let cashtag: String
    }
    public let customerProfile: CustomerProfile?

    public let metadata: [String: String]?

    enum CodingKeys: String, CodingKey {
        case id, status, actions, authFlowTriggers, redirectURL = "redirectUrl", createdAt, updatedAt, expiresAt,
        origin, channel, grants, referenceID = "referenceId", requesterProfile, customerProfile, metadata
    }
}

// MARK: - PaymentAction

public struct PaymentAction: Equatable {
    public let type: PaymentType
    public let scopeID: String
    public let money: Money?
    public let accountReferenceID: String?

    /// When `true`, nil fields will be encoded as `NULL`.
    /// When `false`, nil fields will be omitted.
    /// Defaults to `false`. Set to `true` when used in `UpdateCustomerRequestParams`.
    var clearing: Bool = false

    public static func oneTimePayment(scopeID: String, money: Money?) -> PaymentAction {
        return PaymentAction(
            type: .ONE_TIME_PAYMENT,
            scopeID: scopeID,
            money: money,
            accountReferenceID: nil
        )
    }

    public static func onFilePayment(scopeID: String, accountReferenceID: String?) -> PaymentAction {
        return PaymentAction(
            type: .ON_FILE_PAYMENT,
            scopeID: scopeID,
            money: nil,
            accountReferenceID: accountReferenceID
        )
    }
    enum CodingKeys: String, CodingKey {
        case type, scopeID = "scopeId", amount, currency, accountReferenceID = "accountReferenceId"
    }
}

// Manually decode, to handle treating amount/currency as Money object
extension PaymentAction: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(PaymentType.self, forKey: .type)
        scopeID = try values.decode(String.self, forKey: .scopeID)
        if let amount = try values.decodeIfPresent(UInt.self, forKey: .amount),
           let currencyString = try values.decodeIfPresent(String.self, forKey: .currency),
           let currency = Currency(rawValue: currencyString) {
            money = Money(amount: amount, currency: currency)
        } else {
            money = nil
        }
        accountReferenceID = try values.decodeIfPresent(String.self, forKey: .accountReferenceID)
    }
}

// Manually encode, to handle treating Money object as amount/currency
extension PaymentAction: Encodable {
    public func encode(to encoder: Encoder) throws {
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
}

public enum PaymentType: String, Codable, CaseIterable, Equatable {
    case ONE_TIME_PAYMENT
    case ON_FILE_PAYMENT
}

// MARK: - Primitives

public struct Money: Codable, Equatable {
    public let amount: UInt
    public let currency: Currency

    public init(
        amount: UInt,
        currency: Currency
    ) {
        self.amount = amount
        self.currency = currency
    }
}

public enum Currency: String, Codable, Equatable {
    case USD
}

/// How the customer is expected to interact with the request.
public enum Channel: String, Codable, CaseIterable, Equatable {
    ///  The customer is redirected to Cash App by a mobile application.
    ///  Use this channel for native apps on a customer's device.
    case IN_APP
    /// The customer presents or scans a QR code at a physical location to approve the request.
    case IN_PERSON
    ///  The customer scans a QR code or is redirected to Cash App by a website.
    ///  Not recommended for mobile applications.
    case ONLINE
}

// MARK: - Descriptions

extension CreateCustomerRequestParams: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
CreateCustomerRequestParams:
Actions: \(actions)\n
Redirect URL: \(redirectURL)\n
Channel: \(channel)\n
Reference ID: \(String(describing: referenceID))\n
Metadata: \(String(describing: metadata))
"""
    }
}

extension UpdateCustomerRequestParams: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
UpdateCustomerRequestParams:
Actions: \(actions)\n
Reference ID: \(String(describing: referenceID))\n
Metadata: \(String(describing: metadata))
"""
    }
}

extension CustomerRequest: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
CustomerRequest:
ID: \(id)
Status: \(status.rawValue)
Actions: \(actions)
Channel: \(channel)
Reference ID: \(String(describing: referenceID))
Metadata: \(String(describing: metadata))
"""
    }
}

extension PaymentAction: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch type {
        case .ON_FILE_PAYMENT:
            return """
\n ON_FILE_PAYMENT:
   Scope ID: \(scopeID)
   Account Reference ID: \(String(describing: accountReferenceID))
"""
        case .ONE_TIME_PAYMENT:
            return """
\n ONE_TIME_PAYMENT:
   Scope ID: \(scopeID)
   Account Reference ID: \(String(describing: money))
"""
        }
    }
}
