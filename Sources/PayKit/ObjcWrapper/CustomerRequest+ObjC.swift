//
//  CustomerRequest+ObjC.swift
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

@objcMembers public final class CAPCreateCustomerRequestParams: NSObject {

    // MARK: - Properties

    let createCustomerRequestParams: CreateCustomerRequestParams

    // MARK: - Public Properties

    public var actions: [CAPPaymentAction] {
        createCustomerRequestParams
            .actions
            .map(CAPPaymentAction.init(paymentAction:))
    }

    public var channel: String {
        createCustomerRequestParams.channel.rawValue
    }

    public var redirectURL: URL {
        createCustomerRequestParams.redirectURL
    }

    public var referenceID: String? {
        createCustomerRequestParams.referenceID
    }

    public var metadata: [String: String]? {
        createCustomerRequestParams.metadata
    }

    // MARK: - Init

    init(createCustomerRequestParams: CreateCustomerRequestParams) {
        self.createCustomerRequestParams = createCustomerRequestParams
    }

    // MARK: - Public Init

    public init(
        actions: [CAPPaymentAction],
        channel: CAPChannel,
        redirectURL: URL,
        referenceID: String?,
        metadata: [String: String]?
    ) {
        createCustomerRequestParams = CreateCustomerRequestParams(
            actions: actions.map(\.paymentAction),
            channel: channel.channel,
            redirectURL: redirectURL,
            referenceID: referenceID,
            metadata: metadata
        )
    }

    public init(
        actions: [CAPPaymentAction],
        redirectURL: URL,
        referenceID: String?,
        metadata: [String: String]?
    ) {
        createCustomerRequestParams = CreateCustomerRequestParams(
            actions: actions.map(\.paymentAction),
            channel: .IN_APP,
            redirectURL: redirectURL,
            referenceID: referenceID,
            metadata: metadata
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherCAPCreateCustomerRequestParams = object as? CAPCreateCustomerRequestParams else {
            return false
        }
        return createCustomerRequestParams == otherCAPCreateCustomerRequestParams.createCustomerRequestParams
    }
}

@objcMembers public final class CAPUpdateCustomerRequestParams: NSObject {

    // MARK: - Properties

    let updateCustomerRequestParams: UpdateCustomerRequestParams

    // MARK: - Public Properties

    public var actions: [CAPPaymentAction] {
        updateCustomerRequestParams
            .actions
            .map(CAPPaymentAction.init(paymentAction:))
    }

    public var referenceID: String? {
        updateCustomerRequestParams.referenceID
    }

    public var metadata: [String: String]? {
        updateCustomerRequestParams.metadata
    }

    // MARK: - Init

    init(updateCustomerRequestParams: UpdateCustomerRequestParams) {
        self.updateCustomerRequestParams = updateCustomerRequestParams
    }

    // MARK: - Public Init

    public init(
        actions: [CAPPaymentAction],
        referenceID: String?,
        metadata: [String: String]?
    ) {
        self.updateCustomerRequestParams = UpdateCustomerRequestParams(
            actions: actions.map(\.paymentAction),
            referenceID: referenceID,
            metadata: metadata
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherCAPUpdateCustomerRequestParams = object as? CAPUpdateCustomerRequestParams else {
            return false
        }
        return updateCustomerRequestParams == otherCAPUpdateCustomerRequestParams.updateCustomerRequestParams
    }
}

@objcMembers public final class CAPCustomerRequest: NSObject {

    // MARK: - Properties

    let customerRequest: CustomerRequest

    // MARK: - Public Properties

    public var id: String {
        customerRequest.id
    }

    public var status: String {
        customerRequest.status.rawValue
    }

    public var actions: [CAPPaymentAction] {
        customerRequest
            .actions
            .map(CAPPaymentAction.init(paymentAction:))
    }

    public var authFlowTriggers: CAPCustomerRequestAuthFlowTriggers? {
        customerRequest
            .authFlowTriggers
            .map(CAPCustomerRequestAuthFlowTriggers.init(authFlowTriggers:))
    }

    public var redirectURL: URL? {
        customerRequest.redirectURL
    }

    public var createdAt: Date {
        customerRequest.createdAt
    }

    public var updatedAt: Date {
        customerRequest.updatedAt
    }

    public var expiresAt: Date {
        customerRequest.expiresAt
    }

    public var origin: CAPCustomerRequestOrigin? {
        customerRequest
            .origin
            .map(CAPCustomerRequestOrigin.init(origin:))
    }

    public var channel: String {
        customerRequest.channel.rawValue
    }

    public var grants: [CAPCustomerRequestGrant]? {
        customerRequest.grants?.map(CAPCustomerRequestGrant.init(grant:))
    }

    public var referenceID: String? {
        customerRequest.referenceID
    }

    public var requesterProfile: CAPCustomerRequestRequesterProfile? {
        customerRequest
            .requesterProfile
            .map(CAPCustomerRequestRequesterProfile.init(requesterProfile:))
    }

    public var customerProfile: CAPCustomerRequestCustomerProfile? {
        customerRequest
            .customerProfile
            .map(CAPCustomerRequestCustomerProfile.init(customerProfile:))
    }

    public var metadata: [String: String]? {
        customerRequest.metadata
    }

    // MARK: - Init

    init(customerRequest: CustomerRequest) {
        self.customerRequest = customerRequest
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherCAPCustomerRequest = object as? CAPCustomerRequest else {
            return false
        }
        return customerRequest == otherCAPCustomerRequest.customerRequest
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers public final class CAPCustomerRequestGrant: NSObject {

    // MARK: - Properties

    let grant: CustomerRequest.Grant

    // MARK: - Public Properties

    public var id: String {
        grant.id
    }

    public var customerID: String {
        grant.customerID
    }

    public var action: CAPPaymentAction {
        CAPPaymentAction(paymentAction: grant.action)
    }

    public var status: String {
        grant.status.rawValue
    }

    public var channel: String {
        grant.channel.rawValue
    }

    public var createdAt: Date {
        grant.createdAt
    }

    public var updatedAt: Date {
        grant.updatedAt
    }

    public var expiresAt: Date? {
        grant.expiresAt
    }

    // MARK: - Init

    init(grant: CustomerRequest.Grant) {
        self.grant = grant
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherGrant = object as? CAPCustomerRequestGrant else {
            return false
        }
        return grant == otherGrant.grant
    }
}

@objcMembers public final class CAPCustomerRequestCustomerProfile: NSObject {

    // MARK: - Properties

    let customerProfile: CustomerRequest.CustomerProfile

    // MARK: - Public Properties

    public var id: String {
        customerProfile.id
    }

    public var cashtag: String {
        customerProfile.cashtag
    }

    // MARK: - Init

    init(customerProfile: CustomerRequest.CustomerProfile) {
        self.customerProfile = customerProfile
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherCustomerProfile = object as? CAPCustomerRequestCustomerProfile else {
            return false
        }
        return customerProfile == otherCustomerProfile.customerProfile
    }
}

@objcMembers public final class CAPCustomerRequestRequesterProfile: NSObject {

    // MARK: - Properties

    let requesterProfile: CustomerRequest.RequesterProfile

    // MARK: - Public Properties

    public var name: String {
        requesterProfile.name
    }

    public var logoURL: URL {
        requesterProfile.logoURL
    }

    // MARK: - init

    init(requesterProfile: CustomerRequest.RequesterProfile) {
        self.requesterProfile = requesterProfile
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherRequestRequesterProfile = object as? CAPCustomerRequestRequesterProfile else {
            return false
        }
        return requesterProfile == otherRequestRequesterProfile.requesterProfile
    }
}

@objcMembers public final class CAPCustomerRequestOrigin: NSObject {

    // MARK: - Properties

    let origin: CustomerRequest.Origin

    // MARK: - Public Properties

    public var type: String {
        origin.type.rawValue
    }

    public var id: String? {
        origin.id
    }

    // MARK: - Init

    init(origin: CustomerRequest.Origin) {
        self.origin = origin
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherOrigin = object as? CAPCustomerRequestOrigin else {
            return false
        }
        return origin == otherOrigin.origin
    }
}

@objcMembers public final class CAPCustomerRequestAuthFlowTriggers: NSObject {

    // MARK: - Properties

    let authFlowTriggers: CustomerRequest.AuthFlowTriggers

    // MARK: - Public Properties

    public var qrCodeImageURL: URL {
        authFlowTriggers.qrCodeImageURL
    }

    public var qrCodeSVGURL: URL {
        authFlowTriggers.qrCodeSVGURL
    }

    public var mobileURL: URL {
        authFlowTriggers.mobileURL
    }

    public var refreshesAt: Date {
        authFlowTriggers.refreshesAt
    }

    // MARK: - Init

    init(authFlowTriggers: CustomerRequest.AuthFlowTriggers) {
        self.authFlowTriggers = authFlowTriggers
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherAuthFlowTriggers = object as? CAPCustomerRequestAuthFlowTriggers else {
            return false
        }
        return authFlowTriggers == otherAuthFlowTriggers.authFlowTriggers
    }
}

// MARK: - PaymentAction

@objcMembers public final class CAPPaymentAction: NSObject {

    // MARK: - Private Properties

    let paymentAction: PaymentAction

    // MARK: - Public Properties

    public var type: String {
        paymentAction.type.rawValue
    }

    public var scopeID: String {
        paymentAction.scopeID
    }

    public var money: CAPMoney? {
        paymentAction.money?.capMoney
    }

    public var accountReferenceID: String? {
        paymentAction.accountReferenceID
    }

    // MARK: - Init

    init(paymentAction: PaymentAction) {
        self.paymentAction = paymentAction
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Static Methods

    public static func oneTimePayment(scopeID: String, money: CAPMoney?) -> CAPPaymentAction {
        let paymentAction = PaymentAction.oneTimePayment(scopeID: scopeID, money: money?.money)
        return CAPPaymentAction(paymentAction: paymentAction)
    }

    public static func onFilePayment(scopeID: String, accountReferenceID: String?) -> CAPPaymentAction {
        let paymentAction = PaymentAction.onFilePayment(scopeID: scopeID, accountReferenceID: accountReferenceID)
        return CAPPaymentAction(paymentAction: paymentAction)
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherPaymentAction = object as? CAPPaymentAction else {
            return false
        }
        return paymentAction == otherPaymentAction.paymentAction
    }
}

// MARK: - Money

@objcMembers public final class CAPMoney: NSObject {

    // MARK: - Properties

    let money: Money

    // MARK: - Public Properties

    public var amount: UInt {
        money.amount
    }

    public var currency: CAPCurrency {
        money.currency.capCurrency
    }

    // MARK: - Init

    init(money: Money) {
        self.money = money
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(amount: UInt, currency: CAPCurrency) {
        self.money = Money(amount: amount, currency: currency.currency)
    }

    // MARK: - Equatable

    public override func isEqual(_ object: Any?) -> Bool {
        guard let otherMoney = object as? CAPMoney else {
            return false
        }
        return money == otherMoney.money
    }
}

private extension Money {
    var capMoney: CAPMoney {
        CAPMoney(amount: amount, currency: currency.capCurrency)
    }
}

// MARK: - Currency

@objc public enum CAPCurrency: Int {
    case USD

    var currency: Currency {
        switch self {
        case .USD: return .USD
        }
    }
}

extension Currency {
    var capCurrency: CAPCurrency {
        switch self {
        case .USD: return .USD
        }
    }
}

// MARK: - Channel

@objc public enum CAPChannel: Int {
    ///  The customer is redirected to Cash App by a mobile application.
    ///  Use this channel for native apps on a customer's device.
    case IN_APP
    /// The customer presents or scans a QR code at a physical location to approve the request.
    case IN_PERSON
    ///  The customer scans a QR code or is redirected to Cash App by a website.
    ///  Not recommended for mobile applications.
    case ONLINE

    var channel: Channel {
        switch self {
        case .IN_APP: return .IN_APP
        case .IN_PERSON: return .IN_PERSON
        case .ONLINE: return .ONLINE
        }
    }
}
