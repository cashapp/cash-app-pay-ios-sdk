//
//  CustomerRequestTests.swift
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

class CustomerRequestTests: XCTestCase {

    private lazy var jsonEncoder: JSONEncoder = .payKitEncoder()
    private lazy var jsonDecoder: JSONDecoder = .payKitDecoder()

    func test_deserializePendingRequest_fullyPopulated() throws {
        let json = try fixtureDataForFilename(pendingRequestFilename)
        let requestWrapper = try jsonDecoder.decode(CustomerRequestWrapper.self, from: json)
        XCTAssertEqual(requestWrapper.request, TestValues.fullyPopulatedPendingRequest)
    }

    func test_serializePendingRequest_fullyPopulated() throws {
        let serializedRequest = try jsonEncoder.encode(
            CustomerRequestWrapper(
                request: TestValues.fullyPopulatedPendingRequest
            )
        )
        let fixtureJSON = try fixtureDataForFilename(pendingRequestFilename)

        // The JSON data is unordered, so convert it to a dictionary to compare.
        let fixtureDict = try XCTUnwrap(JSONSerialization.jsonObject(with: fixtureJSON) as? [String: AnyHashable])
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedRequest) as? [String: AnyHashable]
        )
        XCTAssertEqual(fixtureDict, serializedDict)
    }

    func test_deserializeApprovedRequest_fullyPopulated() throws {
        let json = try fixtureDataForFilename(approvedRequestFilename)
        let requestWrapper = try jsonDecoder.decode(CustomerRequestWrapper.self, from: json)
        XCTAssertEqual(requestWrapper.request, TestValues.fullyPopulatedApprovedRequest)
    }

    func test_serializeApprovedRequest_fullyPopulated() throws {
        let serializedRequest = try jsonEncoder.encode(
            CustomerRequestWrapper(
                request: TestValues.fullyPopulatedApprovedRequest
            )
        )
        let fixtureJSON = try fixtureDataForFilename(approvedRequestFilename)

        // The JSON data is unordered, so convert it to a dictionary to compare.
        let fixtureDict = try XCTUnwrap(JSONSerialization.jsonObject(with: fixtureJSON) as? [String: AnyHashable])
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedRequest) as? [String: AnyHashable]
        )
        XCTAssertEqual(fixtureDict, serializedDict)
    }

    let pendingRequestFilename = "pendingRequest-fullyPopulated"
    let approvedRequestFilename = "approvedRequest-fullyPopulated"
}
