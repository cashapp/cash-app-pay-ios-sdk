//
//  AnalyticsServiceTests.swift
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

class AnalyticsServiceTests: XCTestCase {

    func test_observers_added() {
        let foregroundExp = self.expectation(description: "Foreground observer added")
        let backgroundExp = self.expectation(description: "Background observer added")
        let terminateExp = self.expectation(description: "Terminated observer added")

        let mockNotificationObserver = MockNotificationCenter { _, _, name, _ in
            switch name {
            case UIApplication.willEnterForegroundNotification:
                foregroundExp.fulfill()
            case UIApplication.didEnterBackgroundNotification:
                backgroundExp.fulfill()
            case UIApplication.willTerminateNotification:
                terminateExp.fulfill()
            default:
                XCTFail("Unexpected notification handler registered")
            }
        }
        _ = EventStream2(
            appName: "",
            commonParameters: [:],
            store: MockAnalyticsDataSource(),
            client: MockAnalyticsClient(),
            notificationCenter: mockNotificationObserver
        )
        waitForExpectations(timeout: 0.2)
    }

    func test_track_merges_common_params() {
        let exp = expectation(description: "Called insert")
        let mockStore = MockAnalyticsDataSource(insertStub: { event in
            self.XCTAssertEqual(try? event.jsonString(), "{\"test_Client\":\"test\"}")
            exp.fulfill()
        })
        let eventStream = EventStream2(
            appName: "",
            commonParameters: ["Client": "test"],
            store: mockStore,
            client: MockAnalyticsClient()
        )
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.2)
    }

    func test_upload_is_called_with_app_name() {
        let exp = expectation(description: "Client called")
        let mockClient = MockAnalyticsClient { appName, _, _ in
            self.XCTAssertEqual(appName, "app")
            exp.fulfill()
        }
        let eventStream = EventStream2(
            appName: "app",
            commonParameters: [:],
            store: MockAnalyticsDataSource(countStub: { 5 }),
            client: mockClient
        )
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.2)
    }

    func test_events_removed_before_uploading() {
        var events = Array(repeating: UUID(), count: 5).map { AnalyticsEvent(id: $0, catalog: "test", fields: [:]) }

        let removeExpectation = expectation(description: "Remove called")
        let uploadExpectation  = expectation(description: "Upload called")

        let mockStore = MockAnalyticsDataSource(
            countStub: { events.count },
            removeStub: { _ in
                removeExpectation.fulfill()
            },
            queryStub: { limit in
                self.XCTAssertEqual(limit, 5)
                events = []
                return events
            }
        )

        let mockClient = MockAnalyticsClient { _, _, completion in
            uploadExpectation.fulfill()
            completion(.success(()))
        }
        let eventStream = EventStream2(appName: "", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))

        wait(for: [removeExpectation, uploadExpectation], timeout: 0.5, enforceOrder: true)
    }

    func test_5_events_are_batched_per_upload() {
        var eventIds = Array(repeating: UUID(), count: 6)
        let events = eventIds.map { AnalyticsEvent(id: $0, catalog: "test", fields: [:])}
        let exp = expectation(description: "Remove called")
        let mockStore = MockAnalyticsDataSource(
            countStub: { eventIds.count },
            queryStub: { limit in
                self.XCTAssertEqual(limit, 5)
                exp.fulfill()
                eventIds = []
                return events
            }
        )
        let mockClient = MockAnalyticsClient { _, _, completion in
            completion(.success(()))
        }
        let eventStream = EventStream2(appName: "app", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.2)
    }

    func test_successful_upload_triggers_upload_again() {
        var eventIds = Array(repeating: UUID(), count: 11)
        let events = eventIds.map { AnalyticsEvent(id: $0, catalog: "test", fields: [:])}
        let exp = expectation(description: "Upload called")
        exp.expectedFulfillmentCount = 2
        let mockStore = MockAnalyticsDataSource(
            countStub: { eventIds.count },
            queryStub: { limit in
                self.XCTAssertEqual(limit, 5)
                eventIds = eventIds[5...].map { $0 }
                return events
            }
        )
        let mockClient = MockAnalyticsClient { _, _, completion in
            completion(.success(()))
            exp.fulfill()
        }
        let eventStream = EventStream2(appName: "app", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.2)
    }

    func test_failed_upload_triggers_upload_again() {
        var eventIds = Array(repeating: UUID(), count: 11)
        let events = eventIds.map { AnalyticsEvent(id: $0, catalog: "test", fields: [:])}
        let exp = expectation(description: "Upload called")
        exp.expectedFulfillmentCount = 2
        let mockStore = MockAnalyticsDataSource(
            countStub: { eventIds.count },
            queryStub: { limit in
                self.XCTAssertEqual(limit, 5)
                eventIds = eventIds[5...].map { $0 }
                return events
            }
        )
        let mockClient = MockAnalyticsClient { _, _, completion in
            completion(.failure(NetworkError.noResponse))
            exp.fulfill()
        }
        let eventStream = EventStream2(appName: "app", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.2)
    }

    func test_event_is_stored_before_uploading() {
        var eventIds = Array(repeating: UUID(), count: 5)
        let insertExp = expectation(description: "Insert called")
        let uploadExp = expectation(description: "Upload called")
        let mockStore = MockAnalyticsDataSource(
            countStub: { eventIds.count },
            insertStub: { _ in
                insertExp.fulfill()
            }
        )
        let mockClient = MockAnalyticsClient { _, _, completion in
            uploadExp.fulfill()
            eventIds = []
            completion(.success(()))
        }
        let eventStream = EventStream2(appName: "app", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        wait(for: [insertExp, uploadExp], timeout: 0.5, enforceOrder: true)
    }

    func test_inserting_event_does_not_upload_unless_threshold_exceeded() {
        let insertExp = expectation(description: "Insert called")
        let uploadExp = expectation(description: "Upload called")
        uploadExp.isInverted = true
        let mockStore = MockAnalyticsDataSource(
            countStub: { 1 },
            insertStub: { _ in
                insertExp.fulfill()
            }
        )
        let mockClient = MockAnalyticsClient { _, _, completion in
            uploadExp.fulfill()
            completion(.success(()))
        }
        let eventStream = EventStream2(appName: "app", commonParameters: [:], store: mockStore, client: mockClient)
        eventStream.track(AnalyticsEvent(catalog: "test", fields: [:]))
        waitForExpectations(timeout: 0.3)
    }

}

private class MockAnalyticsDataSource: AnalyticsDataSource {
    let countStub: (() -> Int)
    let insertStub: ((AnalyticsEvent) -> Void)
    let removeStub: (([UUID]) -> Void)
    let queryStub: ((Int) -> [AnalyticsEvent])

    init(
        countStub: @escaping (() -> Int) = { 0 },
        insertStub: @escaping ((AnalyticsEvent) -> Void) = { _ in },
        removeStub: @escaping (([UUID]) -> Void) = { _ in },
        queryStub: @escaping ((Int) -> [AnalyticsEvent])  = { _ in [] }
    ) {
        self.countStub = countStub
        self.insertStub = insertStub
        self.removeStub = removeStub
        self.queryStub = queryStub
        super.init()
    }

    override var count: Int {
        countStub()
    }

    override func insert(event: AnalyticsEvent) {
        insertStub(event)
    }

    override func remove(_ eventIds: [UUID]) {
        removeStub(eventIds)
    }

    override func fetch(limit: Int) -> [AnalyticsEvent] {
        queryStub(limit)
    }
}

private class MockAnalyticsClient: AnalyticsClient {
    let uploadStub: ((String, [AnalyticsEvent], (Result<Void, Error>) -> Void) -> Void)

    init(uploadStub: @escaping ((String, [AnalyticsEvent], (Result<Void, Error>) -> Void) -> Void) = { _, _, _ in }) {
        self.uploadStub = uploadStub
        super.init(restService: ResilientRESTService(), endpoint: .production)
    }

    override func upload(
        appName: String,
        events: [AnalyticsEvent],
        completion: @escaping (Result<Void, Error>) -> Void) {
        uploadStub(appName, events, completion)
    }
}
