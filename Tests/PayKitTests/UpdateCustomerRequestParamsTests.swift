//
//  UpdateCustomerRequestParamsTests.swift
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

class UpdateCustomerRequestParamsTests: XCTestCase {

    private lazy var jsonEncoder: JSONEncoder = .payKitEncoder()
    private lazy var jsonDecoder: JSONDecoder = .payKitDecoder()

    func test_serializeUpdateParams_clearAllButActions() throws {
        let params = TestValues.updateCustomerRequestParams_clearAllButActions

        // Try serializing the params to JSON.
        let serializedParams = try jsonEncoder.encode(UpdateCustomerRequestParamsWrapper(params))
        // Load the param fixture from file.
        let fixtureParams = try fixtureDataForFilename(clearAllButActionsFilename)

        // The wrappers won't match because they have different idempotency keys, but the underlying requests
        // should be identical.
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedParams) as? [String: AnyHashable]
        )
        let fixtureDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: fixtureParams) as? [String: AnyHashable]
        )
        XCTAssertEqual(serializedDict["request"]!, fixtureDict["request"]!)
    }

    func test_serializeUpdateParams_clearAmount() throws {
        let params = TestValues.updateCustomerRequestParams_clearAmount

        // Try serializing the params to JSON.
        let serializedParams = try jsonEncoder.encode(UpdateCustomerRequestParamsWrapper(params))
        // Load the param fixture from file.
        let fixtureParams = try fixtureDataForFilename(clearAmountFilename)

        // The wrappers won't match because they have different idempotency keys, but the underlying requests
        // should be identical.
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedParams) as? [String: AnyHashable]
        )
        let fixtureDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: fixtureParams) as? [String: AnyHashable]
        )
        XCTAssertEqual(serializedDict["request"]!, fixtureDict["request"]!)
    }

    let clearAllButActionsFilename = "updateRequestParams-clearAllButActions"
    let clearAmountFilename = "updateRequestParams-clearAmountFromOneTime"
}
