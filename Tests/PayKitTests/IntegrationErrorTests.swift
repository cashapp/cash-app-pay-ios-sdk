//
//  IntegrationErrorTests.swift
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

class IntegrationErrorTests: XCTestCase {

    private lazy var jsonEncoder: JSONEncoder = .payKitEncoder()
    private lazy var jsonDecoder: JSONDecoder = .payKitDecoder()

    func test_serialize_unauthorizedError() throws {
        // Try serializing the error to JSON.
        let serializedError = try jsonEncoder.encode(IntegrationErrorWrapper(errors: [TestValues.unauthorizedError]))

        // Try loading the fixture JSON from file.
        let fixtureError = try fixtureDataForFilename(unauthorizedFilename, in: .errors)

        // The JSON data is unordered, so convert it to a dictionary to compare.
        let fixtureDict = try XCTUnwrap(JSONSerialization.jsonObject(with: fixtureError) as? [String: AnyHashable])
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedError) as? [String: AnyHashable]
        )
        XCTAssertEqual(fixtureDict, serializedDict)
    }

    func test_deserialize_unauthorizedError() throws {
        let fixtureJSON = try fixtureDataForFilename(unauthorizedFilename, in: .errors)
        let errorWrapper = try jsonDecoder.decode(IntegrationErrorWrapper.self, from: fixtureJSON)
        XCTAssertEqual(errorWrapper.errors.first, TestValues.unauthorizedError)
    }

    func test_serialize_brandNotFoundError() throws {
        // Try serializing the error to JSON.
        let serializedError = try jsonEncoder.encode(IntegrationErrorWrapper(errors: [TestValues.brandNotFoundError]))

        // Try loading the fixture JSON from file.
        let fixtureError = try fixtureDataForFilename(brandNotFoundFilename, in: .errors)

        // The JSON data is unordered, so convert it to a dictionary to compare.
        let fixtureDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: fixtureError) as? [String: AnyHashable]
        )
        let serializedDict = try XCTUnwrap(
            JSONSerialization.jsonObject(with: serializedError) as? [String: AnyHashable]
        )
        XCTAssertEqual(fixtureDict, serializedDict)
    }

    func test_deserialize_brandNotFoundError() throws {
        let fixtureJSON = try fixtureDataForFilename(brandNotFoundFilename, in: .errors)
        let errorWrapper = try jsonDecoder.decode(IntegrationErrorWrapper.self, from: fixtureJSON)
        XCTAssertEqual(errorWrapper.errors.first, TestValues.brandNotFoundError)
    }

    func test_deserialize_unexpectedError() throws {
        // IDEMPOTENCY_KEY_REUSED is an unexpected error, so deserialization should fail.
        let fixtureJSON = try fixtureDataForFilename(idempotencyKeyReusedFilename, in: .errors)
        XCTAssertThrowsError(try jsonDecoder.decode(IntegrationErrorWrapper.self, from: fixtureJSON)) { error in
            XCTAssert(error is Swift.DecodingError)
        }
    }

    let unauthorizedFilename = "unauthorized"
    let brandNotFoundFilename = "brandNotFound"
    let idempotencyKeyReusedFilename = "idempotencyKeyReused"
}
