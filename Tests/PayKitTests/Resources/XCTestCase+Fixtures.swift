//
//  XCTestCase+Fixtures.swift
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

extension String: Error {}

private extension Bundle {
    static let fixtures: Bundle = {
        #if COCOAPODS
        return Bundle(for: PayKitTests.self)
        #else
        return Bundle.module
        #endif
    }()
}

extension XCTestCase {

    enum ResourceDirectory {
        case errors
        case fixtures

        var path: String? {
            #if COCOAPODS
            return nil
            #else
            switch self {
            case .errors:
                return "Fixtures/Errors"
            case .fixtures:
                return "Fixtures"
            }
            #endif
        }
    }

    func fixtureDataForFilename(_ filename: String, in directory: ResourceDirectory = .fixtures) throws -> Data {
        guard let url = Bundle.fixtures.url(
            forResource: filename,
            withExtension: "json",
            subdirectory: directory.path
        ) else {
            XCTFail("\(filename).json not found")
            throw "File Not Found \(filename)"
        }
        let fixtureParams = try Data(contentsOf: url)
        return fixtureParams
    }
}

// swiftlint:disable line_length multiline_literal_brackets
enum TestValues {
    static let createCustomerRequestParams = CreateCustomerRequestParams(
        actions: [PaymentAction.onFilePayment(scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t", accountReferenceID: "account4")],
        channel: .IN_APP,
        redirectURL: URL(string: "paykitdemo://callback")!,
        referenceID: "refer_to_me",
        metadata: [
            "key1": "Valuation",
            "key2": "ValuWorld",
            "key3": "Valuminous",
        ]
    )

    static let updateCustomerRequestParams_clearAllButActions = UpdateCustomerRequestParams(
        actions: [PaymentAction.onFilePayment(
            scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
            accountReferenceID: nil
        ), ],
        referenceID: nil,
        metadata: nil
    )

    static let updateCustomerRequestParams_clearAmount = UpdateCustomerRequestParams(
        actions: [PaymentAction.oneTimePayment(
            scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
            money: nil
        ), ],
        referenceID: nil,
        metadata: nil
    )

    static let updateCustomerRequestParams = updateCustomerRequestParams_clearAllButActions

    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return dateFormatter
    }()

    static let customerRequest = fullyPopulatedPendingRequest

    static var fullyPopulatedPendingRequest: CustomerRequest {
        CustomerRequest(
            id: "GRR_mg3saamyqdm29jj9pqjqkedm",
            status: .PENDING,
            actions: [PaymentAction.onFilePayment(
                scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
                accountReferenceID: "account4"
            ), ],
            authFlowTriggers: CustomerRequest.AuthFlowTriggers(
                qrCodeImageURL: URL(string: "https://sandbox.api.cash.app/qr/sandbox/v1/GRR_mg3saamyqdm29jj9pqjqkedm-t61pfg?rounded=0&format=png")!,
                qrCodeSVGURL: URL(string: "https://sandbox.api.cash.app/qr/sandbox/v1/GRR_mg3saamyqdm29jj9pqjqkedm-t61pfg?rounded=0&format=svg")!,
                mobileURL: URL(string: "https://sandbox.api.cash.app/customer-request/v1/requests/GRR_mg3saamyqdm29jj9pqjqkedm/interstitial")!,
                refreshesAt: dateFormatter.date(from: "2022-10-20T20:16:48.036Z")!
            ),
            redirectURL: URL(string: "paykitdemo://callback")!,
            createdAt: dateFormatter.date(from: "2022-10-20T20:16:18.051Z")!,
            updatedAt: dateFormatter.date(from: "2022-10-20T20:16:18.051Z")!,
            expiresAt: dateFormatter.date(from: "2022-10-20T21:16:18.024Z")!,
            origin: CustomerRequest.Origin(type: .DIRECT, id: nil),
            channel: .IN_APP,
            grants: nil, // no grants for pending request
            referenceID: "refer_to_me",
            requesterProfile: CustomerRequest.RequesterProfile(name: "SDK Hacking: The Brand", logoURL: URL(string: "https://franklin-assets.s3.amazonaws.com/merchants/assets/v3/generic/m_category_shopping.png")!),
            customerProfile: nil,
            metadata: [
                "key1": "Valuation",
                "key2": "ValuWorld",
                "key3": "Valuminous",
            ]
        )
    }

    static var fullyPopulatedApprovedRequest: CustomerRequest {
        CustomerRequest(
            id: "GRR_mg3saamyqdm29jj9pqjqkedm",
            status: .APPROVED,
            actions: [PaymentAction.onFilePayment(
                scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
                accountReferenceID: "account4"
            ), ],
            authFlowTriggers: nil,
            redirectURL: URL(string: "paykitdemo://callback")!,
            createdAt: dateFormatter.date(from: "2022-10-20T20:16:18.051Z")!,
            updatedAt: dateFormatter.date(from: "2022-10-20T21:04:10.701Z")!,
            expiresAt: dateFormatter.date(from: "2022-10-20T22:03:43.113Z")!,
            origin: CustomerRequest.Origin(
                type: .DIRECT,
                id: nil
            ),
            channel: .IN_APP,
            grants: approvedRequestGrants, // grants for approved request
            referenceID: "refer_to_me",
            requesterProfile: CustomerRequest.RequesterProfile(
                name: "SDK Hacking: The Brand",
                logoURL: URL(string: "https://franklin-assets.s3.amazonaws.com/merchants/assets/v3/generic/m_category_shopping.png")!
            ),
            customerProfile: CustomerRequest.CustomerProfile(
                id: "CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc",
                cashtag: "$CASHTAG_C_TOKEN"
            ),
            metadata: [
                "key1": "Valuation",
                "key2": "ValuWorld",
                "key3": "Valuminous",
            ]
        )
    }

    static var fullyPopulatedDeclinedRequest: CustomerRequest {
        CustomerRequest(
            id: "GRR_mg3saamyqdm29jj9pqjqkedm",
            status: .DECLINED,
            actions: [PaymentAction.onFilePayment(
                scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
                accountReferenceID: "account4"
            ), ],
            authFlowTriggers: nil,
            redirectURL: URL(string: "paykitdemo://callback")!,
            createdAt: dateFormatter.date(from: "2022-10-20T20:16:18.051Z")!,
            updatedAt: dateFormatter.date(from: "2022-10-20T21:04:10.701Z")!,
            expiresAt: dateFormatter.date(from: "2022-10-20T22:03:43.113Z")!,
            origin: CustomerRequest.Origin(
                type: .DIRECT,
                id: nil
            ),
            channel: .IN_APP,
            grants: approvedRequestGrants, // grants for approved request
            referenceID: "refer_to_me",
            requesterProfile: CustomerRequest.RequesterProfile(
                name: "SDK Hacking: The Brand",
                logoURL: URL(string: "https://franklin-assets.s3.amazonaws.com/merchants/assets/v3/generic/m_category_shopping.png")!
            ),
            customerProfile: CustomerRequest.CustomerProfile(
                id: "CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc",
                cashtag: "$CASHTAG_C_TOKEN"
            ),
            metadata: [
                "key1": "Valuation",
                "key2": "ValuWorld",
                "key3": "Valuminous",
            ]
        )
    }

    static var fullyPopulatedProcessingRequest: CustomerRequest {
        CustomerRequest(
            id: "GRR_mg3saamyqdm29jj9pqjqkedm",
            status: .PROCESSING,
            actions: [PaymentAction.onFilePayment(
                scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
                accountReferenceID: "account4"
            ),
            ],
            authFlowTriggers: nil,
            redirectURL: URL(string: "paykitdemo://callback")!,
            createdAt: dateFormatter.date(from: "2022-10-20T20:16:18.051Z")!,
            updatedAt: dateFormatter.date(from: "2022-10-20T21:04:10.701Z")!,
            expiresAt: dateFormatter.date(from: "2022-10-20T22:03:43.113Z")!,
            origin: CustomerRequest.Origin(
                type: .DIRECT,
                id: nil
            ),
            channel: .IN_APP,
            grants: approvedRequestGrants, // grants for approved request
            referenceID: "refer_to_me",
            requesterProfile: CustomerRequest.RequesterProfile(
                name: "SDK Hacking: The Brand",
                logoURL: URL(string: "https://franklin-assets.s3.amazonaws.com/merchants/assets/v3/generic/m_category_shopping.png")!
            ),
            customerProfile: CustomerRequest.CustomerProfile(
                id: "CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc",
                cashtag: "$CASHTAG_C_TOKEN"
            ),
            metadata: [
                "key1": "Valuation",
                "key2": "ValuWorld",
                "key3": "Valuminous",
            ]
        )
    }

    // Grants

    static var approvedRequestGrants: [CustomerRequest.Grant] {
        return [CustomerRequest.Grant(
            id: "GRG_AZYyHv2DwQltw0SiCLTaRb73y40XFe2dWM690WDF9Btqn-uTCYAUROa4ciwCdDnZcG4PuY1m_i3gwHODiO8DSf9zdMmRl1T0SM267vzuldnBs246-duHZhcehhXtmhfU8g",
            customerID: "CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc",
            action: PaymentAction.onFilePayment(
                scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t",
                accountReferenceID: "account4"
            ),
            status: .ACTIVE,
            type: .EXTENDED,
            channel: .IN_APP,
            createdAt: dateFormatter.date(from: "2022-10-20T21:03:43.249Z")!,
            updatedAt: dateFormatter.date(from: "2022-10-20T21:03:43.249Z")!,
            expiresAt: dateFormatter.date(from: "2027-10-19T21:03:43.159Z")!
        ),
        ]
    }

    // API Error

    static  var internalServerError: APIError {
        APIError(
            category: .API_ERROR,
            code: .INTERNAL_SERVER_ERROR,
            detail: "An internal server error has occurred.",
            field: nil
        )
    }

    // Integration Error

    static var unauthorizedError: IntegrationError {
        IntegrationError(
            category: .AUTHENTICATION_ERROR,
            code: .UNAUTHORIZED,
            detail: "The request specified a client ID of 'FAKE_CLIENT_ID', but a client with that ID does not exist. Please ensure the client ID being passed is correct and contact Cash App API support if you are unable to resolve this issue.",
            field: nil
        )
    }

    static var brandNotFoundError: IntegrationError {
        IntegrationError(
            category: .INVALID_REQUEST_ERROR,
            code: .BRAND_NOT_FOUND,
            detail: "The requested brand could not be found.",
            field: nil
        )
    }

    // Unexpected Error

    static var idempotencyKeyReusedError: UnexpectedError {
        UnexpectedError(
            category: "INVALID_REQUEST_ERROR",
            code: "IDEMPOTENCY_KEY_REUSED",
            detail: "Idempotency key already in use, request body checksum does not match",
            field: nil
        )
    }
}
