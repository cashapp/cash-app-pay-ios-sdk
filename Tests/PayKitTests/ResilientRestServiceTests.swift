//
//  ResilientRESTServiceTests.swift
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

final class ResilientRESTServiceTests: XCTestCase {

    private var url: URL!

    override func setUp() {
        super.setUp()
        url = URL(string: "https://api.cash.app/")!
    }

    override func tearDown() {
        url = nil
        super.tearDown()
    }

    func test_execute_performs_request_and_calls_handler() {
        let requestExpectation = expectation(description: "Executed request")
        let mock = MockURLSession { request in
            self.XCTAssertEqual(request.url, self.url)
            requestExpectation.fulfill()
            return (Data(), HTTPURLResponse(), nil)
        }

        let handlerExpectation = expectation(description: "Handler called")
        let service = ResilientRESTService(urlSession: mock.session)
        service.execute(request: URLRequest(url: url), retryPolicy: nil) { data, _, _ in
            XCTAssertNotNil(data)
            handlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 0.2)
    }

    func test_failure_without_retry_calls_handler() {
        let requestExpectation = expectation(description: "Executed request")
        let mock = MockURLSession { request in
            self.XCTAssertEqual(request.url, self.url)
            requestExpectation.fulfill()
            return (nil, nil, NSError(domain: "", code: 5))
        }

        let handlerExpectation = expectation(description: "Handler called")
        let service = ResilientRESTService(urlSession: mock.session)
        service.execute(request: URLRequest(url: url), retryPolicy: nil) { _, _, error in
            self.XCTAssertEqual((error as? NSError)?.code, 5)
            handlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 0.2)
    }

    func test_execute_with_retry_eventually_fails_and_calls_handler() {
        let requestExpectation = expectation(description: "Executed request")
        requestExpectation.expectedFulfillmentCount = 2
        let mock = MockURLSession { request in
            self.XCTAssertEqual(request.url, self.url)
            requestExpectation.fulfill()
            return (nil, nil, NSError(domain: "", code: 5))
        }

        let handlerExpectation = expectation(description: "Handler called")
        let service = ResilientRESTService(urlSession: mock.session)
        service.execute(
            request: URLRequest(url: url),
            retryPolicy: .exponential(
                delay: 1,
                maximumNumberOfAttempts: 1
            )
        ) { _, _, error in
            self.XCTAssertEqual((error as? NSError)?.code, 5)
            handlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func test_execute_with_retry_stops_after_success() {
        let stubError = NSError(domain: "", code: 5)
        let stubResponse = "".data(using: .utf8)
        let requestExpectation = expectation(description: "Executed request")
        requestExpectation.expectedFulfillmentCount = 2

        var responses: [(Data?, URLResponse?, Error?)] = [(nil, nil, stubError), (stubResponse, HTTPURLResponse(), nil)]
        let mock = MockURLSession { request in
            self.XCTAssertEqual(request.url, self.url)
            requestExpectation.fulfill()
            return responses.removeFirst()
        }

        let handlerExpectation = expectation(description: "Handler called")
        let service = ResilientRESTService(urlSession: mock.session)
        service.execute(
            request: URLRequest(url: url),
            retryPolicy:
                    .exponential(
                        delay: 1,
                        maximumNumberOfAttempts: 10
                    )
        ) { data, _, _ in
            XCTAssertNotNil(data)
            handlerExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
