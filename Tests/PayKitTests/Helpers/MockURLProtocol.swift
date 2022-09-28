//
//  MockURLProtocol.swift
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

class MockURLSession {
    let session: URLSession

    // swiftlint:disable:next large_tuple
    init(handler: ((URLRequest) -> (Data?, URLResponse?, Error?))?) {
        URLProtocolStub.loadingHandler = handler

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        self.session = URLSession(configuration: configuration)
    }

    deinit {
        URLProtocolStub.loadingHandler = nil
    }
}

private final class URLProtocolStub: URLProtocol {

    // swiftlint:disable:next large_tuple
    static var loadingHandler: ((URLRequest) -> (Data?, URLResponse?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let (data, response, error) = Self.loadingHandler!(request)

        if let error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let response, let data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        } else {
            fatalError("No stubs provided")
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Intentionally left blank
    }
}
