//
//  File.swift
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

final class CustomerRequest_ExtensionsTests: XCTestCase {
    private var now: Date!
    private var url: URL!

    override func setUpWithError() throws {
        try super.setUpWithError()
        now = Date()
        url = try XCTUnwrap(URL(string: "https://block.xyz"))
    }

    override func tearDown() {
        now = nil
        url = nil
        super.tearDown()
    }

    func test_expired() throws {
        let authFlowTrigger = CustomerRequest.AuthFlowTriggers(
            qrCodeImageURL: url,
            qrCodeSVGURL: url,
            mobileURL: url,
            refreshesAt: Date(timeInterval: -30, since: now)
        )

        XCTAssertTrue(authFlowTrigger.isExpired(on: now))
    }

    func test_notExpired() throws {
        let authFlowTrigger = CustomerRequest.AuthFlowTriggers(
            qrCodeImageURL: url,
            qrCodeSVGURL: url,
            mobileURL: url,
            refreshesAt: Date(timeInterval: 30, since: now)
        )
        XCTAssertFalse(authFlowTrigger.isExpired(on: now))
    }

    func test_expiredBecauseOfJitter() {
        let authFlowTrigger = CustomerRequest.AuthFlowTriggers(
            qrCodeImageURL: url,
            qrCodeSVGURL: url,
            mobileURL: url,
            refreshesAt: Date(timeInterval: 10, since: now)
        )
        XCTAssertTrue(authFlowTrigger.isExpired(on: now))
    }
}
