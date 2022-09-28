//
//  AnalyticsService.swift
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
import UIKit

protocol AnalyticsService {
    func track(_ event: AnalyticsEvent)
}

class EventStream2: AnalyticsService {

    // MARK: - Properties

    private let appName: String
    private let commonParameters: [String: Loggable]

    private let store: AnalyticsDataSource
    private let client: AnalyticsClient

    private let workQueue = OperationQueue()

    private let eventBatchSize: Int

    private var isBatchSizeExceeded: Bool {
        store.count >= eventBatchSize
    }

    // MARK: - Lifecycle

    /**
     - Parameters:
     - appName: The appname in EventStream2.
     - commonParameters: Parameters to be combined with each event event sending.
     - store: The event store used to buffer events before sending.
     - client: The networking client used for analytics.
     - eventBatchSize: The batch size for events sent to ES2. Default is 5.
     - timeInterval: The maximum time interval before events are uploaded. Default is 5 seconds.
     - notificationCenter: The Notification Center.
     */
    init(
        appName: String,
        commonParameters: [String: Loggable],
        store: AnalyticsDataSource,
        client: AnalyticsClient,
        eventBatchSize: Int = 5,
        timeInterval: TimeInterval = 5,
        notificationCenter: NotificationCenter = .default) {
            self.appName = appName
            self.commonParameters = commonParameters
            self.store = store
            self.client = client
            self.eventBatchSize = eventBatchSize

            notificationCenter.addObserver(
                self,
                selector: #selector(enqueueUpload),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )

            notificationCenter.addObserver(
                self,
                selector: #selector(enqueueUpload),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil
            )

            notificationCenter.addObserver(
                self,
                selector: #selector(enqueueUpload),
                name: UIApplication.willTerminateNotification,
                object: nil
            )

            let timer = Timer(timeInterval: timeInterval, repeats: true) {  [weak self] _ in
                self?.enqueueUpload()
            }

            RunLoop.current.add(timer, forMode: .common)
        }

    // MARK: - Public

    func track(_ event: AnalyticsEvent) {
        event.add(commonFields: commonParameters)
        workQueue.addOperation { [weak self] in
            guard let self else { return }
            self.store.insert(event: event)
            if self.isBatchSizeExceeded == true {
                self.uploadEvents()
            }
        }
    }

    // MARK: - Private

    @objc
    private func enqueueUpload() {
        workQueue.addOperation { [weak self] in
            self?.uploadEvents()
        }
    }

    private func uploadEvents() {
        precondition(OperationQueue.current == workQueue)
        guard store.count > 0 else { return }
        let events = store.fetch(limit: eventBatchSize)
        store.remove(events.map(\.id))
        client.upload(appName: appName, events: events) { [weak self] _ in
            guard let self else { return }
            if self.isBatchSizeExceeded == true {
                self.enqueueUpload()
            }
        }
    }
}

extension EventStream2 {
    static let appName = "paykitsdk-ios"

    enum CommonFields: String {
        case clientID = "client_id"
        case platform = "platform"
        case sdkVersion = "sdk_version"
        case clientUA = "client_ua"
    }
}
