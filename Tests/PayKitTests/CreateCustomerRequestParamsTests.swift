//
//  CreateCustomerRequestParamsTests.swift
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

class CreateCustomerRequestParamsTests: XCTestCase {

    private lazy var jsonEncoder: JSONEncoder = .payKitEncoder()
    private lazy var jsonDecoder: JSONDecoder = .payKitDecoder()

    func test_constructor_defaults_to_in_app_channel() throws {
        let url = try XCTUnwrap(URL(string: "https://block.xyz/"))
        let params = CreateCustomerRequestParams(actions: [], redirectURL: url, referenceID: nil, metadata: nil)
        XCTAssertEqual(params.channel, .IN_APP)
    }

    func test_serializeCreateParams_fullyPopulated() throws {
        let params = TestValues.createCustomerRequestParams

        // Try serializing the params to JSON.
        let serializedParams = try jsonEncoder.encode(CreateCustomerRequestParamsWrapper(params))

        // Try loading the param fixture from file.
        let fixtureParams = try fixtureDataForFilename(createRequestParamsFilename)

        // The wrappers won't match because they have different idempotency keys, but the underlying requests
        // should be identical.
        let serializedDict = try XCTUnwrap(JSONSerialization.jsonObject(with: serializedParams) as? [String: Any])
        let fixtureDict = try XCTUnwrap(JSONSerialization.jsonObject(with: fixtureParams) as? [String: Any])
        XCTAssertNotNil(serializedDict["request"])
        XCTAssertNotNil(fixtureDict["request"])
        XCTAssertEqual(
            try XCTUnwrap(JSONSerialization.data(withJSONObject: serializedDict["request"]!)),
            try XCTUnwrap(JSONSerialization.data(withJSONObject: fixtureDict["request"]!))
        )
    }

    func test_deserializeCreateParams_fullyPopulated() throws {
        // Load the param fixture from file.
        let fixtureParams = try fixtureDataForFilename(createRequestParamsFilename)

        // Try deserializing the params to a struct.
        let deserializedParams = try jsonDecoder.decode(CreateCustomerRequestParamsWrapper.self, from: fixtureParams)

        let params = TestValues.createCustomerRequestParams
        XCTAssertEqual(deserializedParams.request, params)
    }

    let createRequestParamsFilename = "createRequestParams-fullyPopulated"
}
