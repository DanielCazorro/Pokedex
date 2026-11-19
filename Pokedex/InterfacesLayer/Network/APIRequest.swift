//
//  APIRequest.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import CryptoKit
import Foundation

nonisolated enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

nonisolated struct APIRequest: Sendable {
    let url: URL
    let method: HTTPMethod
    let body: (any Encodable & Sendable)?
    /// Seconds a cached response stays fresh. `nil` disables the cache for this request.
    let cacheMaxAge: TimeInterval?
}

// MARK: - URLRequest

extension APIRequest {
    func urlRequest() throws(APIError) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw APIError.invalidRequest
            }
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}

extension URLRequest {
    /// Stable file name for the response cache: hash of method, URL and body.
    var cacheKey: String {
        var key = Data((httpMethod ?? .empty).utf8)
        key.append(Data((url?.absoluteString ?? .empty).utf8))
        key.append(httpBody ?? Data())
        return SHA256.hash(data: key).map { String(format: "%02x", $0) }.joined()
    }
}
