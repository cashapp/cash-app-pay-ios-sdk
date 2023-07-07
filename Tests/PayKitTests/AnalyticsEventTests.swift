//
//  AnalyticsEventTests.swift
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

@testable import PayKit
import XCTest

// swiftlint:disable line_length multiline_literal_brackets multiline_arguments_brackets
class AnalyticsEventTests: XCTestCase {
    func test_init_with_loggable_fields() {
        let event = AnalyticsEvent(catalog: "", fields: ["hello": "world"])
        XCTAssertEqual(try? event.jsonString(), "{\"hello\":\"world\"}")
    }

    func test_merge_combines_fields() {
        let event = AnalyticsEvent(catalog: "test", fields: [:])
        event.add(commonFields: ["new": "value"])
        XCTAssertEqual(try? event.jsonString(), "{\"test_new\":\"value\"}")
    }

    func test_merge_takes_newer_values_on_confict() {
        let event = AnalyticsEvent(catalog: "test", fields: ["key": "value 1"])
        event.add(commonFields: ["key": "value 2"])
        XCTAssertEqual(try? event.jsonString(), "{\"test_key\":\"value 2\"}")
    }

    func test_json_string() {
        let event = AnalyticsEvent(catalog: "", fields: ["boolean_field": true])
        XCTAssertEqual(try? event.jsonString(), "{\"boolean_field\":true}")
    }

    // MARK: - InitializationEvent

    func test_initialization_event() {
        let event = InitializationEvent()
        XCTAssertEqual(event.fields.count, 0)
    }

    // MARK: - ListenerEvent

    func test_listener_event() {
        let event = ListenerEvent(listenerUID: "test", isAdded: true)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_event_listener_is_added",
            "mobile_cap_pk_event_listener_listener_uid",
        ])
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "true",
            "test",
        ])
    }

    // MARK: - CustomerRequestEvent

    func test_create_request() {
        let event = CustomerRequestEvent.createRequest(params: TestValues.createCustomerRequestParams)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action",
            "mobile_cap_pk_customer_request_create_actions",
            "mobile_cap_pk_customer_request_create_channel",
            "mobile_cap_pk_customer_request_create_metadata",
            "mobile_cap_pk_customer_request_create_redirect_url",
            "mobile_cap_pk_customer_request_create_reference_id",
        ])
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "create",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "IN_APP",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "FILTERED",
            "FILTERED",
        ])
    }

    func test_update_request() {
        let event = CustomerRequestEvent.updateRequest(request: TestValues.customerRequest, params: TestValues.updateCustomerRequestParams)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action", "mobile_cap_pk_customer_request_actions", "mobile_cap_pk_customer_request_auth_mobile_url",
            "mobile_cap_pk_customer_request_channel", "mobile_cap_pk_customer_request_created_at", "mobile_cap_pk_customer_request_customer_request_id",
            "mobile_cap_pk_customer_request_metadata", "mobile_cap_pk_customer_request_origin_type", "mobile_cap_pk_customer_request_redirect_url",
            "mobile_cap_pk_customer_request_reference_id", "mobile_cap_pk_customer_request_requester_name", "mobile_cap_pk_customer_request_status",
            "mobile_cap_pk_customer_request_update_actions", "mobile_cap_pk_customer_request_updated_at",
        ])
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "update",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":null}\"]",
            "1666296978051000",

        ])
    }

    func test_ready_to_authorize_request() {
        let event = CustomerRequestEvent.readyToAuthorize(request: TestValues.customerRequest)
        XCTAssertEqual(event.fields.keys.sorted(), expectedKeys)
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "ready_to_authorize",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "1666296978051000",
        ])
    }

    func test_redirect_request() {
        let event = CustomerRequestEvent.redirect(request: TestValues.customerRequest)
        XCTAssertEqual(event.fields.keys.sorted(), expectedKeys)
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "redirect",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "1666296978051000",
        ])
    }

    func test_polling_request() {
        let event = CustomerRequestEvent.polling(request: TestValues.customerRequest)
        XCTAssertEqual(event.fields.keys.sorted(), expectedKeys)
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "polling",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "1666296978051000",
        ])
    }

    func test_declined_request() {
        let event = CustomerRequestEvent.declined(request: TestValues.customerRequest)
        XCTAssertEqual(event.fields.keys.sorted(), expectedKeys)
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "declined",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "1666296978051000",
        ])
    }

    func test_approved_request() {
        let event = CustomerRequestEvent.approved(request: TestValues.customerRequest, grants: TestValues.approvedRequestGrants)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action",
            "mobile_cap_pk_customer_request_actions",
            "mobile_cap_pk_customer_request_approved_grants",
            "mobile_cap_pk_customer_request_auth_mobile_url",
            "mobile_cap_pk_customer_request_channel",
            "mobile_cap_pk_customer_request_created_at",
            "mobile_cap_pk_customer_request_customer_request_id",
            "mobile_cap_pk_customer_request_metadata",
            "mobile_cap_pk_customer_request_origin_type",
            "mobile_cap_pk_customer_request_redirect_url",
            "mobile_cap_pk_customer_request_reference_id",
            "mobile_cap_pk_customer_request_requester_name",
            "mobile_cap_pk_customer_request_status",
            "mobile_cap_pk_customer_request_updated_at",
        ])
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "approved",
            "[\"{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"}\"]",
            "[\"{\"status\":\"ACTIVE\",\"channel\":\"IN_APP\",\"action\":{\"type\":\"ON_FILE_PAYMENT\",\"scope_id\":\"BRAND_9kx6p0mkuo97jnl025q9ni94t\",\"account_reference_id\":\"FILTERED\"},\"id\":\"GRG_AZYyHv2DwQltw0SiCLTaRb73y40XFe2dWM690WDF9Btqn-uTCYAUROa4ciwCdDnZcG4PuY1m_i3gwHODiO8DSf9zdMmRl1T0SM267vzuldnBs246-duHZhcehhXtmhfU8g\",\"created_at\":1666299823249000,\"expires_at\":1823979823159000,\"type\":\"EXTENDED\",\"customer_id\":\"CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc\",\"updated_at\":1666299823249000}\"]",
            "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial",
            "IN_APP",
            "1666296978051000",
            "GRR_mg3saamyqdm29jj9pqjqkedm",
            "{\"key1\":\"Valuation\",\"key2\":\"ValuWorld\",\"key3\":\"Valuminous\"}",
            "DIRECT",
            "FILTERED",
            "FILTERED",
            "SDK Hacking: The Brand",
            "PENDING",
            "1666296978051000",
        ])
    }

    func test_api_error() {
        let event = CustomerRequestEvent.error(TestValues.internalServerError)
        XCTAssertEqual(
            event.fields.keys.sorted(), [
                "mobile_cap_pk_customer_request_action",
                "mobile_cap_pk_customer_request_error_category",
                "mobile_cap_pk_customer_request_error_code",
                "mobile_cap_pk_customer_request_error_detail",
            ]
        )
        XCTAssertEqual(
            sortedFieldValues(event.fields), [
                "api_error",
                "API_ERROR",
                "INTERNAL_SERVER_ERROR",
                "An internal server error has occurred.",
            ]
        )
    }

    func test_integration_error() {
        let event = CustomerRequestEvent.error(TestValues.unauthorizedError)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action",
            "mobile_cap_pk_customer_request_error_category",
            "mobile_cap_pk_customer_request_error_code",
            "mobile_cap_pk_customer_request_error_detail", ]
        )
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "integration_error",
            "AUTHENTICATION_ERROR",
            "UNAUTHORIZED",
            "The request specified a client ID of \'FAKE_CLIENT_ID\', but a client with that ID does not exist. Please ensure the client ID being passed is correct and contact Cash App API support if you are unable to resolve this issue.",
        ])
    }

    func test_unexpected_error() {
        let event = CustomerRequestEvent.error(TestValues.idempotencyKeyReusedError)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action",
            "mobile_cap_pk_customer_request_error_category",
            "mobile_cap_pk_customer_request_error_code",
            "mobile_cap_pk_customer_request_error_detail", ]
        )
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "unexpected_error",
            "INVALID_REQUEST_ERROR",
            "IDEMPOTENCY_KEY_REUSED",
            "Idempotency key already in use, request body checksum does not match",
        ])
    }

    func test_network_error() {
        let event = CustomerRequestEvent.error(NetworkError.noResponse)
        XCTAssertEqual(event.fields.keys.sorted(), [
            "mobile_cap_pk_customer_request_action",
            "mobile_cap_pk_customer_request_error_detail", ]
        )
        XCTAssertEqual(sortedFieldValues(event.fields), [
            "network_error",
            "The operation couldn’t be completed. (PayKit.NetworkError error 3.)",
        ])
    }

    // MARK: - Private

    private let expectedKeys = [
        "mobile_cap_pk_customer_request_action", "mobile_cap_pk_customer_request_actions", "mobile_cap_pk_customer_request_auth_mobile_url",
        "mobile_cap_pk_customer_request_channel", "mobile_cap_pk_customer_request_created_at", "mobile_cap_pk_customer_request_customer_request_id",
        "mobile_cap_pk_customer_request_metadata", "mobile_cap_pk_customer_request_origin_type", "mobile_cap_pk_customer_request_redirect_url",
        "mobile_cap_pk_customer_request_reference_id", "mobile_cap_pk_customer_request_requester_name", "mobile_cap_pk_customer_request_status",
        "mobile_cap_pk_customer_request_updated_at",
    ]

    private func sortedFieldValues(_ values: [String: Loggable]) -> [String] {
        values.sorted(by: { (lhs, rhs) in lhs.key < rhs.key }).map { $0.value.loggableDescription.description }
    }
}
