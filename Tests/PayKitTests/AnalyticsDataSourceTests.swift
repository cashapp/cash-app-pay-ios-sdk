//
//  AnalyticsDataSourceTests.swift
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

class AnalyticsDataSourceTests: XCTestCase {
    private var dataSource: AnalyticsDataSource!

    override func setUp() {
        super.setUp()
        self.dataSource = AnalyticsDataSource()
    }

    override func tearDown() {
        self.dataSource = nil
        super.tearDown()
    }

    func test_insert() {
        let event = AnalyticsEvent(catalog: "test", fields: ["test": "key"])

        XCTAssertEqual(dataSource.count, 0)
        dataSource.insert(event: event)
        XCTAssertEqual(dataSource.count, 1)
    }

    func test_query_limit() {
        let event1 = AnalyticsEvent(catalog: "test", fields: ["test": "key"])
        let event2 = AnalyticsEvent(catalog: "test", fields: ["test": 5])

        dataSource.insert(event: event1)
        dataSource.insert(event: event2)

        XCTAssertEqual(dataSource.fetch(limit: 1).count, 1)
    }

    func test_remove() {
        let id = UUID()
        let event = AnalyticsEvent(id: id, catalog: "test", fields: ["test": "key"])

        dataSource.insert(event: event)
        dataSource.remove([event.id])

        XCTAssertEqual(dataSource.count, 0)
    }

    func test_max_event_count_is_not_exceeded() {
        let events = Array(repeating: AnalyticsEvent(catalog: "", fields: [:]), count: 300)
        let store = AnalyticsDataSource(events: events)
        XCTAssertEqual(store.count, 300)
        store.insert(event: AnalyticsEvent(catalog: "", fields: [:]))
        XCTAssertEqual(store.count, 300)
    }

    func test_max_event_count() {
        XCTAssertEqual(AnalyticsDataSource.maxEventCount, 300)
    }
}
