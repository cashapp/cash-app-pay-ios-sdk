//
//  PayKit+EndpointTest.swift
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

class CashAppPay_EndpointTest: XCTestCase {
    func test_endpoint_url() {
        XCTAssertEqual(CashAppPay.Endpoint.staging.baseURL.absoluteString, "https://api.cashstaging.app/")
        XCTAssertEqual(CashAppPay.Endpoint.sandbox.baseURL.absoluteString, "https://sandbox.api.cash.app/")
        XCTAssertEqual(CashAppPay.Endpoint.production.baseURL.absoluteString, "https://api.cash.app/")
    }

    func test_endpoint_analytics_endpoint() {
        XCTAssertEqual(CashAppPay.Endpoint.staging.analyticsEndpoint, .staging)
        XCTAssertEqual(CashAppPay.Endpoint.production.analyticsEndpoint, .production)
        XCTAssertEqual(CashAppPay.Endpoint.sandbox.analyticsEndpoint, .production)
    }

    func test_analytics_field() {
        XCTAssertEqual(CashAppPay.Endpoint.staging.analyticsField, "staging")
        XCTAssertEqual(CashAppPay.Endpoint.production.analyticsField, "production")
        XCTAssertEqual(CashAppPay.Endpoint.sandbox.analyticsField, "sandbox")
    }
}
