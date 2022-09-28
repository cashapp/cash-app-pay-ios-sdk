//
//  RESTService.swift
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

protocol RESTService {
    func execute(
        request: URLRequest,
        retryPolicy: RetryPolicy?,
        completion: @escaping ((Data?, URLResponse?, Error?) -> Void)
    )
}

final class ResilientRESTService: RESTService {

    // MARK: - Properties

    private var urlSession: URLSession

    // MARK: - Lifecycle

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - RESTService

    func execute(
        request: URLRequest,
        retryPolicy: RetryPolicy?,
        completion: @escaping ((Data?, URLResponse?, Error?) -> Void)
    ) {
        let request = HTTPRequest(urlRequest: request, retryPolicy: retryPolicy, handler: completion)
        performRequest(request: request)
    }

    // MARK: Private

    private func performRequest(request: HTTPRequest) {
        let task = urlSession.dataTask(with: request.urlRequest) { [weak self] data, response, error in
            self?.handleResponse(for: request, data: data, response: response, error: error)
        }
        task.resume()
    }

    private func handleResponse(for request: HTTPRequest, data: Data?, response: URLResponse?, error: Error?) {
        // Retry transport errors only.
        let isSuccessful = (data != nil) && (error == nil) && (response as? HTTPURLResponse != nil)
        guard !isSuccessful, let retryLockout = request.retryPolicy?.lockout else {
            // Complete the request.
            request.handler(data, response, error)
            return
        }
        retry(request: request, delay: retryLockout)
    }

    private func retry(request: HTTPRequest, delay: TimeInterval) {
        let retryRequest = HTTPRequest(
            urlRequest: request.urlRequest,
            retryPolicy: request.retryPolicy?.decrement(),
            handler: request.handler
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.performRequest(request: retryRequest)
        }
    }
}
