//
//  AccessModifierTests.swift
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

import PayKit
import XCTest

class AccessModifierTests: XCTestCase {
    func test_create_customer_request_params() throws {
        let url = try XCTUnwrap(URL(string: "https://block.xyz/"))
        let request = CreateCustomerRequestParams(
            actions: [
                .onFilePayment(
                    scopeID: "scope",
                    accountReferenceID: "reference"
                ),
            ],
            channel: .IN_APP,
            redirectURL: url,
            referenceID: "reference",
            metadata: ["meta": "data"]
        )

        XCTAssertEqual(request.actions.count, 1)
        XCTAssertEqual(request.channel, .IN_APP)
        XCTAssertEqual(request.redirectURL, url)
        XCTAssertEqual(request.referenceID, "reference")
        XCTAssertEqual(request.metadata, ["meta": "data"])
    }

    func test_update_customer_request_params() {
        let request = UpdateCustomerRequestParams(
            actions: [
                .onFilePayment(
                    scopeID: "scope",
                    accountReferenceID:
                        "reference"
                ),
            ],
            referenceID: "reference",
            metadata: ["meta": "data"]
        )

        XCTAssertEqual(request.actions.count, 1)
        XCTAssertEqual(request.referenceID, "reference")
        XCTAssertEqual(request.metadata, ["meta": "data"])
    }

    func test_customer_request() {
        let request = TestValues.customerRequest

        XCTAssertEqual(request.id, "GRR_mg3saamyqdm29jj9pqjqkedm")
        XCTAssertEqual(request.status, .PENDING)
        XCTAssertEqual(request.actions.count, 1)
        XCTAssertNotNil(request.authFlowTriggers)
        XCTAssertEqual(request.redirectURL, URL(string: "paykitdemo://callback")!)
        XCTAssertNotNil(request.createdAt)
        XCTAssertNotNil(request.updatedAt)
        XCTAssertNotNil(request.expiresAt)
        XCTAssertEqual(request.channel, .IN_APP)
        XCTAssertNotNil(request.origin)
        XCTAssertNotNil(request.authFlowTriggers)
        XCTAssertEqual(request.referenceID, "refer_to_me")
        XCTAssertNotNil(request.requesterProfile)
        XCTAssertNil(request.customerProfile)
        XCTAssertNotNil(request.metadata)
    }

    func test_auth_flow_triggers() throws {
        let flowTriggers = try XCTUnwrap(TestValues.customerRequest.authFlowTriggers)
        XCTAssertNotNil(flowTriggers.qrCodeImageURL)
        XCTAssertNotNil(flowTriggers.qrCodeSVGURL)
        XCTAssertNotNil(flowTriggers.mobileURL)
        XCTAssertNotNil(flowTriggers.refreshesAt)
    }

    func test_origin() throws {
        let origin = try XCTUnwrap(TestValues.customerRequest.origin)
        XCTAssertNil(origin.id)
        XCTAssertEqual(origin.type, .DIRECT)
    }

    func test_grants() throws {
        let grant = try XCTUnwrap(TestValues.approvedRequestGrants.first)

        XCTAssertEqual(
            grant.id,
            "GRG_AZYyHv2DwQltw0SiCLTaRb73y40XFe"
            + "2dWM690WDF9Btqn-uTCYAUROa4ciwCdDnZcG4PuY1m_i3gwHODiO8D"
            + "Sf9zdMmRl1T0SM267vzuldnBs246-duHZhcehhXtmhfU8g"
        )
        XCTAssertEqual(grant.customerID, "CST_AYVkuLw-sT3OKZ7a_nhNTC_L2ekahLgGrS-EM_QhW4OTrGMbi59X1eCclH0cjaxoLObc")
        XCTAssertEqual(
            grant.action,
            .onFilePayment(scopeID: "BRAND_9kx6p0mkuo97jnl025q9ni94t", accountReferenceID: "account4")
        )
    }

    func test_payment_action() {
        let onfilePayment = PaymentAction.onFilePayment(scopeID: "scope", accountReferenceID: "reference")
        XCTAssertEqual(onfilePayment.scopeID, "scope")
        XCTAssertNil(onfilePayment.money)
        XCTAssertEqual(onfilePayment.type, .ON_FILE_PAYMENT)
        XCTAssertEqual(onfilePayment.accountReferenceID, "reference")
    }

    func test_money() {
        let money = Money(amount: 100, currency: .USD)
        XCTAssertEqual(money.amount, 100)
        XCTAssertEqual(money.currency, .USD)
    }
}
