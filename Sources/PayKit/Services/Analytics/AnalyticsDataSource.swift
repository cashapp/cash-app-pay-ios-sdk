//
//  AnalyticsDataSource.swift
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

import Foundation

class AnalyticsDataSource {

    // MARK: - Static Properties

    static let maxEventCount = 300

    // MARK: - Private Properties

    private var events: [AnalyticsEvent]

    // MARK: - Lifecycle

    init(events: [AnalyticsEvent] = []) {
        self.events = events
    }

    // MARK: - Public Properties

    var count: Int {
        events.count
    }

    // MARK: - Public

    func insert(event: AnalyticsEvent) {
        guard count < AnalyticsDataSource.maxEventCount else {
            Log.write("Too many Analytics Events dropping event id: \(event.id)")
            return
        }
        events.append(event)
    }

    func fetch(limit: Int) -> [AnalyticsEvent] {
        events.prefix(limit).map { $0 }
    }

    func remove(_ eventIds: [UUID]) {
        let eventIdSet = Set(eventIds)
        events.removeAll(where: { eventIdSet.contains($0.id) })
    }
}
