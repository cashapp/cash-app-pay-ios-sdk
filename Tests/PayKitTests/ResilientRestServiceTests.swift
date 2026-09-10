//
//  ResilientRestServiceTests.swift
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
        var requestCount = 0
        var handlerCount = 0
        var receivedData: Data?
        let service = ResilientRESTService(
            requestExecutor: { request, completion in
                self.XCTAssertEqual(request.url, self.url)
                requestCount += 1
                completion(Data(), HTTPURLResponse(), nil)
            },
            retryScheduler: unexpectedRetryScheduler
        )

        service.execute(request: URLRequest(url: url), retryPolicy: nil) { data, _, _ in
            handlerCount += 1
            receivedData = data
        }

        XCTAssertEqual(requestCount, 1)
        XCTAssertEqual(handlerCount, 1)
        XCTAssertNotNil(receivedData)
    }

    func test_failure_without_retry_calls_handler() {
        var requestCount = 0
        var handlerCount = 0
        var receivedError: Error?
        let service = ResilientRESTService(
            requestExecutor: { request, completion in
                self.XCTAssertEqual(request.url, self.url)
                requestCount += 1
                completion(nil, nil, NSError(domain: "", code: 5))
            },
            retryScheduler: unexpectedRetryScheduler
        )

        service.execute(request: URLRequest(url: url), retryPolicy: nil) { _, _, error in
            handlerCount += 1
            receivedError = error
        }

        XCTAssertEqual(requestCount, 1)
        XCTAssertEqual(handlerCount, 1)
        XCTAssertEqual((receivedError as? NSError)?.code, 5)
    }

    func test_execute_with_retry_eventually_fails_and_calls_handler() {
        let retryScheduler = TestRetryScheduler()
        var requestCount = 0
        var handlerCount = 0
        var receivedError: Error?
        let service = ResilientRESTService(
            requestExecutor: { request, completion in
                self.XCTAssertEqual(request.url, self.url)
                requestCount += 1
                completion(nil, nil, NSError(domain: "", code: 5))
            },
            retryScheduler: retryScheduler.schedule
        )

        service.execute(
            request: URLRequest(url: url),
            retryPolicy: .exponential(
                delay: 1,
                maximumNumberOfAttempts: 1
            )
        ) { _, _, error in
            handlerCount += 1
            receivedError = error
        }

        XCTAssertEqual(requestCount, 1)
        XCTAssertEqual(handlerCount, 0)
        XCTAssertEqual(retryScheduler.nextDelay, 0)

        retryScheduler.runNext()

        XCTAssertEqual(requestCount, 2)
        XCTAssertEqual(handlerCount, 1)
        XCTAssertEqual(retryScheduler.count, 0)
        XCTAssertEqual((receivedError as? NSError)?.code, 5)
    }

    func test_execute_with_retry_stops_after_success() {
        let stubError = NSError(domain: "", code: 5)
        let stubResponse = "".data(using: .utf8)
        let retryScheduler = TestRetryScheduler()
        var responses: [(Data?, URLResponse?, Error?)] = [
            (nil, nil, stubError),
            (stubResponse, HTTPURLResponse(), nil),
        ]
        var requestCount = 0
        var handlerCount = 0
        var receivedData: Data?
        let service = ResilientRESTService(
            requestExecutor: { request, completion in
                self.XCTAssertEqual(request.url, self.url)
                requestCount += 1
                let response = responses.removeFirst()
                completion(response.0, response.1, response.2)
            },
            retryScheduler: retryScheduler.schedule
        )

        service.execute(
            request: URLRequest(url: url),
            retryPolicy: .exponential(
                delay: 1,
                maximumNumberOfAttempts: 10
            )
        ) { data, _, _ in
            handlerCount += 1
            receivedData = data
        }

        XCTAssertEqual(requestCount, 1)
        XCTAssertEqual(handlerCount, 0)
        XCTAssertEqual(retryScheduler.nextDelay, 0)

        retryScheduler.runNext()

        XCTAssertEqual(requestCount, 2)
        XCTAssertEqual(handlerCount, 1)
        XCTAssertEqual(retryScheduler.count, 0)
        XCTAssertNotNil(receivedData)
    }

    private func unexpectedRetryScheduler(delay: TimeInterval, work _: @escaping () -> Void) {
        XCTFail("Unexpected retry after \(delay) seconds")
    }
}

private final class TestRetryScheduler {

    private var retries: [(delay: TimeInterval, work: () -> Void)] = []

    var count: Int {
        retries.count
    }

    var nextDelay: TimeInterval? {
        retries.first?.delay
    }

    func schedule(delay: TimeInterval, work: @escaping () -> Void) {
        retries.append((delay: delay, work: work))
    }

    func runNext() {
        retries.removeFirst().work()
    }
}
