//
//  AnalyticsEvent.swift
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

open class AnalyticsEvent {

    // MARK: - properties

    let id: UUID
    let timestamp: Date
    let catalog: String
    private(set) var fields: [String: Loggable]

    // MARK: - Lifecycle

    /**
     - Parameters:
     - id: The UUID of the event.
     - timestamp: The time of the event.
     - catalog: The catalog from ES2.
     - fields: The partially qualified parameter names for the catalog fields. Nil values are removed.
     */
    init(id: UUID = UUID(), timestamp: Date = Date(), catalog: String, fields: [String: Loggable?]) {
        self.id = id
        self.timestamp = timestamp
        self.catalog = catalog
        self.fields = AnalyticsEvent.buildFieldKey(from: catalog, fields: fields.compactMapValues { $0 })
    }

    // MARK: - Public methods

    /// Adds the `commonFields`  to the existing `fields` merging the catalog name with the parameter key
    /// to create a fully qualified field entry.
    func add(commonFields: [String: Loggable]) {
        let mergedFields = AnalyticsEvent.buildFieldKey(from: catalog, fields: commonFields)
        fields.merge(mergedFields) { (_, new) in new }
    }

    func jsonString() throws -> String? {
        let data = try JSONSerialization.data(withJSONObject: fields.mapValues(\.loggableDescription.object))
        return String(data: data, encoding: .utf8)
    }

    // MARK: - Private static methods

    private static func buildFieldKey(from catalog: String, fields: [String: Loggable]) -> [String: Loggable] {
        fields.reduce(into: [:]) {
            let (key, value) = $1
            let compositeKey = catalog.isEmpty ? key : [catalog, key].joined(separator: "_")
            $0[compositeKey] = value
        }
    }
}

// MARK: - InitializationEvent

final class InitializationEvent: AnalyticsEvent {
    init() {
        super.init(catalog: "mobile_cap_pk_initialization", fields: [:])
    }
}

// MARK: - ListenerEvent

final class ListenerEvent: AnalyticsEvent {
    private enum PropertyKey: String {
        case listenerUID = "listener_uid", isAdded = "is_added"
    }

    init(listenerUID: String, isAdded: Bool) {
        super.init(catalog: "mobile_cap_pk_event_listener", fields: [
            PropertyKey.listenerUID.rawValue: listenerUID,
            PropertyKey.isAdded.rawValue: isAdded,
        ])
    }
}

// MARK: - CustomerRequestEvent

final class CustomerRequestEvent: AnalyticsEvent {
    private enum PropertyKey: String {
        enum Action: String {
            case create, update, readyToAuthorize = "ready_to_authorize", redirect, polling, declined, approved
            case refreshing
            case apiError = "api_error", integrationError = "integration_error"
            case unexpectedError = "unexpected_error", networkError = "network_error"
        }

        case action
        case createActions = "create_actions"
        case createChannel = "create_channel"
        case createRedirectURL = "create_redirect_url"
        case createReferenceID = "create_reference_id"
        case createMetadata = "create_metadata"
        case customerRequestID = "customer_request_id"
        case status
        case actions
        case authMobileURL = "auth_mobile_url"
        case redirectURL = "redirect_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case originType = "origin_type"
        case originID = "origin_id"
        case channel
        case grants
        case referenceID = "reference_id"
        case requesterName = "requester_name"
        case customerID = "customer_id"
        case customerCashtag = "customer_cashtag"
        case metadata
        case updateActions = "update_actions"
        case updateReferenceID = "update_reference_id"
        case updateMetadata = "update_metadata"
        case approvedGrants = "approved_grants"
        case errorCategory = "error_category"
        case errorCode = "error_code"
        case errorDetail = "error_detail"
        case errorField = "error_field"
    }

    let action: String

    private init(
        action: PropertyKey.Action,
        request: CustomerRequest? = nil,
        createParams: CreateCustomerRequestParams? = nil,
        updateParams: UpdateCustomerRequestParams? = nil,
        grants: [CustomerRequest.Grant]? = nil,
        errorCategory: String? = nil,
        errorCode: String? = nil,
        errorDetail: String? = nil,
        errorField: String? = nil
    ) {
        self.action = action.rawValue
        super.init(catalog: "mobile_cap_pk_customer_request", fields: Dictionary(uniqueKeysWithValues: [
            PropertyKey.action: action.rawValue,
            .createActions: createParams?.actions.map(LoggablePaymentAction.init(paymentAction:)),
            .createChannel: createParams?.channel.rawValue,
            .createRedirectURL: createParams?.redirectURL.redacted,
            .createReferenceID: createParams?.referenceID?.redacted,
            .createMetadata: createParams?.metadata,
            .customerRequestID: request?.id,
            .status: request?.status.rawValue,
            .actions: request?.actions.map(LoggablePaymentAction.init(paymentAction:)),
            .authMobileURL: request?.authFlowTriggers?.mobileURL,
            .redirectURL: request?.redirectURL?.redacted,
            .createdAt: request?.createdAt,
            .updatedAt: request?.updatedAt,
            .originType: request?.origin?.type.rawValue,
            .originID: request?.origin?.id,
            .channel: request?.channel.rawValue,
            .grants: request?.grants?.map(LoggableGrant.init(grant:)),
            .referenceID: request?.referenceID?.redacted,
            .requesterName: request?.requesterProfile?.name,
            .customerID: request?.customerProfile?.id,
            .customerCashtag: request?.customerProfile?.cashtag.redacted,
            .metadata: request?.metadata,
            .updateActions: updateParams?.actions.map(LoggablePaymentAction.init(paymentAction:)),
            .updateReferenceID: updateParams?.referenceID?.redacted,
            .updateMetadata: updateParams?.metadata,
            .approvedGrants: grants?.map(LoggableGrant.init(grant:)),
            .errorCategory: errorCategory,
            .errorCode: errorCode,
            .errorDetail: errorDetail,
            .errorField: errorField,
        ].map { (key, value: Loggable?) in (key.rawValue, value) }))
    }

    static func createRequest(params: CreateCustomerRequestParams) -> CustomerRequestEvent {
        .init(action: .create, createParams: params)
    }

    static func updateRequest(request: CustomerRequest, params: UpdateCustomerRequestParams) -> CustomerRequestEvent {
        .init(action: .update, request: request, updateParams: params)
    }

    static func readyToAuthorize(request: CustomerRequest) -> CustomerRequestEvent {
        .init(action: .readyToAuthorize, request: request)
    }

    static func redirect(request: CustomerRequest) -> CustomerRequestEvent {
        .init(action: .redirect, request: request)
    }

    static func polling(request: CustomerRequest) -> CustomerRequestEvent {
        .init(action: .polling, request: request)
    }

    static func declined(request: CustomerRequest) -> CustomerRequestEvent {
        .init(action: .declined, request: request)
    }

    static func approved(request: CustomerRequest, grants: [CustomerRequest.Grant]) -> CustomerRequestEvent {
        .init(action: .approved, request: request, grants: grants)
    }

    static func refreshing(request: CustomerRequest) -> CustomerRequestEvent {
        .init(action: .refreshing, request: request)
    }

    static func error(_ error: APIError) -> CustomerRequestEvent {
        .init(
            action: .apiError,
            errorCategory: error.category.rawValue,
            errorCode: error.code.rawValue,
            errorDetail: error.detail,
            errorField: error.field
        )
    }

    static func error(_ error: IntegrationError) -> CustomerRequestEvent {
        .init(
            action: .integrationError,
            errorCategory: error.category.rawValue,
            errorCode: error.code.rawValue,
            errorDetail: error.detail,
            errorField: error.field
        )
    }

    static func error(_ error: UnexpectedError) -> CustomerRequestEvent {
        .init(
            action: .unexpectedError,
            errorCategory: error.category,
            errorCode: error.code,
            errorDetail: error.detail,
            errorField: error.field
        )
    }

    static func error(_ error: NetworkError) -> CustomerRequestEvent {
        .init(action: .networkError, errorDetail: error.localizedDescription)
    }
}
