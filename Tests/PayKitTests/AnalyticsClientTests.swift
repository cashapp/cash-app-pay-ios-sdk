//
//  AnalyticsClientTests.swift
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

class AnalyticsClientTests: XCTestCase {

    private let event = AnalyticsEvent(catalog: "catlog", fields: ["hello": "world"])

    func test_event_stream_2_params() throws {
        let param = EventStream2Params(appName: "App", event: event)
        XCTAssertEqual(param.appName, "App")

        XCTAssertEqual(try param.event.jsonString(), try event.jsonString())
    }

    func test_endpoint() {
        XCTAssertEqual(AnalyticsClient.Endpoint.staging.baseURL.absoluteString, "https://api.squareupstaging.com/")
        XCTAssertEqual(AnalyticsClient.Endpoint.production.baseURL.absoluteString, "https://api.squareup.com/")
    }

    func test_request_body() {
        let expectation = self.expectation(description: "Uploaded")
        let mock = MockRestService { request, retry, _ in
            self.XCTAssertEqual(retry, .exponential(maximumNumberOfAttempts: 5))
            self.XCTAssertEqual(request.url?.absoluteString, "https://api.squareup.com/2.0/log/eventstream")
            self.XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertNotNil(request.httpBody)
            expectation.fulfill()
        }

        let client = AnalyticsClient(restService: mock, endpoint: .production)
        client.upload(appName: "app", events: [event]) { _ in }

        waitForExpectations(timeout: 0.5)
    }

    func test_analytics_date_encoder_uses_rounded_ms() throws {
        let date = try XCTUnwrap(
            DateComponents(
                calendar: Calendar(identifier: .gregorian),
                timeZone: .init(secondsFromGMT: 0),
                year: 2022,
                month: 4,
                day: 20,
                hour: 8,
                minute: 30,
                second: 45
            ).date
        )
        let data = try JSONEncoder.eventStream2Encoder().encode(date)
        XCTAssertEqual(String(data: data, encoding: .utf8), "1650443445000000")
    }
}
