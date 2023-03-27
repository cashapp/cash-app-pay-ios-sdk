//
//  AnalyticsClient.swift
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

class AnalyticsClient {

    // MARK: - Properties

    private let restService: RESTService

    private let apiPath = "2.0/log/eventstream"
    private var baseURL: URL {
        URL(string: apiPath, relativeTo: endpoint.baseURL)!
    }

    private var requestHeaders: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }

    private let encoder: JSONEncoder = .eventStream2Encoder()

    // MARK: - Public Properties

    private let endpoint: Endpoint

    // MARK: - Lifecycle

    init(restService: RESTService, endpoint: Endpoint) {
        self.restService = restService
        self.endpoint = endpoint
    }

    // MARK: - Public

    func upload(
        appName: String,
        events: [AnalyticsEvent],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let params = events.map { EventStream2Params(appName: appName, event: $0) }
        let eventsCollection = EventStream2CollectionParams(events: params)

        let jsonParams: Data
        do {
            jsonParams = try encoder.encode(eventsCollection)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(DebugError.parseError(events)))
            }
            return
        }

        var request = URLRequest(url: baseURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = jsonParams

        restService.execute(
            request: request,
            retryPolicy: .exponential(maximumNumberOfAttempts: 5)
        ) { _, _, error in
            if let error {
                Log.write("Failed to upload analytics events with error \(error)")
            }
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
    }
}

// MARK: - Endpoint

extension AnalyticsClient {
    enum Endpoint {
        case production
        case staging

        var baseURL: URL {
            switch self {
            case .production:
                return URL(string: "https://api.squareup.com/")!
            case .staging:
                return URL(string: "https://api.squareupstaging.com/")!
            }
        }
    }
}

// MARK: - Request Models

struct EventStream2CollectionParams: Encodable {
    let events: [EventStream2Params]
}

struct EventStream2Params: Encodable {
    let appName: String
    let event: AnalyticsEvent

    init(appName: String, event: AnalyticsEvent) {
        self.appName = appName
        self.event = event
    }

    enum CodingKeys: CodingKey {
        case appName
        case catalogName
        case recordedAtUsec
        case uuid
        case jsonData
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appName, forKey: .appName)
        try container.encode(event.catalog, forKey: .catalogName)
        try container.encode(event.timestamp, forKey: .recordedAtUsec)
        try container.encode(event.id.uuidString, forKey: .uuid)
        try container.encode(event.jsonString(), forKey: .jsonData)
    }
}
