//
//  NetworkManagerTests.swift
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

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager {
        return NetworkManager(clientID: "CASH_CLIENT_SANDBOX", endpoint: .sandbox)
    }

    func test_headers() {
        XCTAssertEqual(
            networkManager.requestHeaders.keys.sorted(),
            ["Accept", "Authorization", "Content-Type", "User-Agent"]
        )
    }

    func test_parsing_request() throws {
        let json = try fixtureDataForFilename(approvedRequestFilename)

        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .failure(let error):
            XCTFail("Received failure with error \(error), expected success")
        case .success(let customerRequest):
            XCTAssertNotNil(customerRequest)
        }
    }

    func test_parsing_apiError() throws {
        let json = try fixtureDataForFilename(internalServerErrorFilename, in: .errors)

        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is APIError)
            guard let internalServerError = error as? APIError else {
                XCTFail("Unexpected result")
                return
            }
            XCTAssertEqual(internalServerError.category, .API_ERROR)
            XCTAssertEqual(internalServerError.code, .INTERNAL_SERVER_ERROR)
        }
    }

    func test_parsing_integrationError() throws {
        let json = try fixtureDataForFilename(unauthorizedErrorFilename, in: .errors)

        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is IntegrationError)
            guard let unauthorizedError = error as? IntegrationError else {
                XCTFail("Unexpected result")
                return
            }
            XCTAssertEqual(unauthorizedError.category, .AUTHENTICATION_ERROR)
            XCTAssertEqual(unauthorizedError.code, .UNAUTHORIZED)
        }
    }

    func test_parsing_unexpectedError() throws {
        let json = try fixtureDataForFilename(idempotencyKeyReusedErrorFilename, in: .errors)

        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is UnexpectedError)
            guard let unauthorizedError = error as? UnexpectedError else {
                XCTFail("Unexpected result")
                return
            }
            XCTAssertEqual(unauthorizedError.category, "INVALID_REQUEST_ERROR")
            XCTAssertEqual(unauthorizedError.code, "IDEMPOTENCY_KEY_REUSED")
        }
    }

    func test_parsing_emptyErrorArray() throws {
        let json = try fixtureDataForFilename(emptyErrorArrayFilename, in: .errors)

        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is UnexpectedError)
            XCTAssertEqual(error as? UnexpectedError, UnexpectedError.emptyErrorArray)
        }
    }

    func test_parsing_noResponse() throws {
        let result = networkManager.parseResponseData(nil, response: nil, error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.noResponse)
        }
    }

    func test_parsing_nilData() throws {
        let response = HTTPURLResponse()
        let result = networkManager.parseResponseData(nil, response: response, error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.nilData(response))
        }
    }

    func test_parsing_systemError() throws {
        let systemError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNotConnectedToInternet
        )
        let result = networkManager.parseResponseData(nil, response: nil, error: systemError)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.systemError(systemError))
        }
    }

    func test_parsing_invalidJSON() throws {
        let json = try fixtureDataForFilename(invalidJSONFilename, in: .errors)
        let result = networkManager.parseResponseData(json, response: HTTPURLResponse(), error: nil)
        switch result {
        case .success(let customerRequest):
            XCTFail("Received success with request \(customerRequest), expected failure")
        case .failure(let error):
            XCTAssert(error is NetworkError)
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidJSON(json))
        }
    }

    let approvedRequestFilename = "approvedRequest-fullyPopulated"
    let internalServerErrorFilename = "internalServerError"
    let unauthorizedErrorFilename = "unauthorized"
    let idempotencyKeyReusedErrorFilename = "idempotencyKeyReused"
    let emptyErrorArrayFilename = "emptyErrorArray"
    let invalidJSONFilename = "invalidJSON"

}
