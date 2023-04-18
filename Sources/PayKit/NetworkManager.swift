//
//  NetworkManager.swift
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

class NetworkManager {

    private let clientID: String

    private lazy var jsonEncoder: JSONEncoder = .payKitEncoder()
    private lazy var jsonDecoder: JSONDecoder = .payKitDecoder()

    private let apiPath = "customer-request/v1/requests"
    private var baseURL: URL {
        URL(string: apiPath, relativeTo: endpoint.baseURL)!
    }

    var requestHeaders: [String: String] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Client " + clientID,
            "User-Agent": UserAgent.userAgent,
        ]
    }

    private let restService: RESTService

    // MARK: - Visible API

    init(clientID: String, endpoint: CashAppPay.Endpoint) {
        self.clientID = clientID
        self.endpoint = endpoint
        self.restService = ResilientRESTService()
    }

    let endpoint: CashAppPay.Endpoint

    func createCustomerRequest(
        params: CreateCustomerRequestParams,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        guard let jsonParams = try? jsonEncoder.encode(CreateCustomerRequestParamsWrapper(params)) else {
            DispatchQueue.main.async {
                completionHandler(.failure(DebugError.parseError(params)))
            }
            return
        }

        var request = URLRequest(url: baseURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = jsonParams
        performRequest(request, completionHandler: completionHandler)
    }

    func updateCustomerRequest(
        _ request: CustomerRequest,
        with params: UpdateCustomerRequestParams,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        guard let jsonParams = try? jsonEncoder.encode(UpdateCustomerRequestParamsWrapper(params)) else {
            DispatchQueue.main.async {
                completionHandler(.failure(DebugError.parseError(params)))
            }
            return
        }

        let url = baseURL.appendingPathComponent(request.id)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = jsonParams
        performRequest(request, completionHandler: completionHandler)
    }

    func retrieveCustomerRequest(
        id: String,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        let url = baseURL.appendingPathComponent(id)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = requestHeaders
        performRequest(request, completionHandler: completionHandler)
    }

    // MARK: - Internal methods

    func performRequest(
        _ request: URLRequest,
        completionHandler: @escaping (Result<CustomerRequest, Error>) -> Void
    ) {
        restService.execute(
            request: request,
            retryPolicy: .exponential(maximumNumberOfAttempts: 5)
        ) { [weak self] (data, response, error) -> Void in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                completionHandler(strongSelf.parseResponseData(data, response: response, error: error))
            }
        }
    }

    func parseResponseData(_ data: Data?, response: URLResponse?, error: Error?) -> (Result<CustomerRequest, Error>) {
        if let error {
            return .failure(NetworkError.systemError(error as NSError))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.noResponse)
        }

        guard let data else {
            return .failure(NetworkError.nilData(httpResponse))
        }

        // Try to parse the data as a CustomerRequest. If successful, we're done.
        if let customerRequest = try? jsonDecoder.decode(CustomerRequestWrapper.self, from: data).request {
            return .success(customerRequest)
        } else if let errors = try? jsonDecoder.decode(APIErrorWrapper.self, from: data).errors {
            // If that parse fails, try making an APIError from the data.
            return .failure(errors.first ?? UnexpectedError.emptyErrorArray)
            // If that parse fails, try making an IntegrationError from the data.
        } else if let errors = try? jsonDecoder.decode(IntegrationErrorWrapper.self, from: data).errors {
            return .failure(errors.first ?? UnexpectedError.emptyErrorArray)
            // If we can't make an IntegrationError, try the generic UnexpectedError and return that.
        } else if let errors = try? jsonDecoder.decode(UnexpectedErrorWrapper.self, from: data).errors {
            return .failure(errors.first ?? UnexpectedError.emptyErrorArray)
        } else {
            // If none of those works, something's really wrong with the data, so tell the dev so.
            return .failure(NetworkError.invalidJSON(data))
        }
    }
}

enum DebugError: Error {
    case parseError(CustomDebugStringConvertible)
    case noRedirectURL(CustomerRequest)
}

extension CashAppPay.Endpoint {
    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://api.cash.app/")!
        case .sandbox:
            return URL(string: "https://sandbox.api.cash.app/")!
        case .staging:
            return URL(string: "https://api.cashstaging.app/")!
        }
    }
}

struct CustomerRequestWrapper: Codable {
    let request: CustomerRequest
}

struct CreateCustomerRequestParamsWrapper: Codable {
    let request: CreateCustomerRequestParams
    let idempotencyKey: String

    init(_ params: CreateCustomerRequestParams) {
        self.request = params
        self.idempotencyKey = UUID().uuidString
    }
}

struct UpdateCustomerRequestParamsWrapper: Codable {
    let request: UpdateCustomerRequestParams
    init(_ params: UpdateCustomerRequestParams) {
        self.request = params
    }
}
