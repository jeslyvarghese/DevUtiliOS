//
//  RESTClient.swift
//
//
//  Created by Jesly Varghese
//

import Foundation

/// Rule for Paths
public protocol Path {
    func asURL(parameters: [String: String]) -> URL
}

/// Error representing there was no valid response from server
public struct NoResponseError: Error {}

/// Error representing there was no data in the response
public struct NoDataError: Error {}

/// Error raised when the server responds with any 5XX errors
public struct ServerError: Error {
    let statusCode: Int
    let response: HTTPURLResponse?
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case path = "PATCH"
}

/// A structure encapsulating any response from API Client
public struct RESTResponse {
    public let data: Data?
    public let response: HTTPURLResponse?
}

/// A simple RESTClient class
open class RESTClient {
    private var baseURL: URL
    private let urlSession: URLSession
    private let genericHeaders: [String: String]
    private let genericParameters: [String: String]

    public init(
        baseURL: String,
        session: URLSession = URLSession.shared,
        genericHeaders: [String: String] = [:],
        genericParameters: [String: String] = [:]
    ) {
        guard let baseURL = URL(string: baseURL) else {
            fatalError()
        }
        self.baseURL = baseURL
        urlSession = session
        self.genericParameters = genericParameters
        self.genericHeaders = genericHeaders
    }

    @discardableResult
    open func get(
        path: Path,
        parameters: [String: String] = [:],
        headers: [String: String] = [:],
        _ completion: @escaping (Result<RESTResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return perform(
            method: .get,
            path: path,
            parameters: parameters,
            headers: headers,
            data: nil
        ) {
            completion($0)
        }
    }

    @discardableResult
    open func post(
        path: Path,
        parameters: [String: String] = [:],
        headers: [String: String] = [:],
        data: Data?,
        _ completion: @escaping (Result<RESTResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return perform(
            method: .post,
            path: path,
            parameters: parameters,
            headers: headers,
            data: data
        ) {
            completion($0)
        }
    }

    @discardableResult
    open func put(
        path: Path,
        parameters: [String: String] = [:],
        headers: [String: String] = [:],
        data: Data?,
        _ completion: @escaping (Result<RESTResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return perform(
            method: .put,
            path: path,
            parameters: parameters,
            headers: headers,
            data: data
        ) {
            completion($0)
        }
    }

    @discardableResult
    open func delete(
        path: Path,
        parameters: [String: String],
        headers: [String: String] = [:],
        _ completion: @escaping (Result<RESTResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        return perform(
            method: .delete,
            path: path,
            parameters: parameters,
            headers: headers,
            data: nil
        ) {
            completion($0)
        }
    }

    @discardableResult
    private func perform(
        method: HTTPMethod,
        path: Path,
        parameters: [String: String] = [:],
        headers: [String: String] = [:],
        data: Data?,
        _ completion: @escaping (Result<RESTResponse, Error>) -> Void
    ) -> URLSessionDataTask {
        let combinedParams = parameters.merging(genericParameters) {
            current, _ in current
        }
        let url = path.asURL(parameters: combinedParams)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NoResponseError()))
                return
            }
            guard (200 ... 299).contains(httpResponse.statusCode) else {
                completion(
                    .failure(
                        ServerError(
                            statusCode: httpResponse.statusCode,
                            response: httpResponse
                        )
                    )
                )
                return
            }
            guard let data = data else {
                completion(.failure(NoResponseError()))
                return
            }
            completion(
                .success(
                    RESTResponse(
                        data: data,
                        response: httpResponse
                    )
                )
            )
        }
        task.resume()
        return task
    }
}
