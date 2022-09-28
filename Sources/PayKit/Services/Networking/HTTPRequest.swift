//
//  HTTPRequest.swift
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

struct HTTPRequest {
    let urlRequest: URLRequest
    let retryPolicy: RetryPolicy?
    let handler: (Data?, URLResponse?, Error?) -> Void

    init(
        urlRequest: URLRequest,
        retryPolicy: RetryPolicy?,
        handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.urlRequest = urlRequest
        self.retryPolicy = retryPolicy
        self.handler = handler
    }
}
