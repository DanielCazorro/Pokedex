//
//  APIClient.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

protocol APIClient {
    func execute<Response: Decodable & Sendable>(_ request: APIRequest) async throws(APIError) -> Response
}

/// Sends requests through an `HTTPTransport`, caches responses on disk and falls back to the cached copy when the
/// network fails.
final class URLSessionAPIClient: APIClient {
    private let transport: HTTPTransport
    private let cache: ResponseCache

    init(transport: HTTPTransport = URLSession.shared, cache: ResponseCache = .api) {
        self.transport = transport
        self.cache = cache
    }

    func execute<Response: Decodable & Sendable>(_ request: APIRequest) async throws(APIError) -> Response {
        let urlRequest = try request.urlRequest()
        guard let cacheMaxAge = request.cacheMaxAge else {
            return try await Self.decode(send(urlRequest))
        }
        let cacheKey = urlRequest.cacheKey
        let cachedEntry = await cache.entry(for: cacheKey)
        if let cachedEntry, cachedEntry.age < cacheMaxAge {
            return try await Self.decode(cachedEntry.data)
        }
        do {
            let data = try await send(urlRequest)
            let response: Response = try await Self.decode(data)
            await cache.store(data, for: cacheKey)
            return response
        } catch .network {
            guard let cachedEntry else { throw APIError.network }
            return try await Self.decode(cachedEntry.data)
        }
    }

    // MARK: - Private

    private func send(_ urlRequest: URLRequest) async throws(APIError) -> Data {
        let result: (data: Data, response: URLResponse)
        do {
            result = try await transport.send(urlRequest)
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.cancelled
        } catch is CancellationError {
            throw APIError.cancelled
        } catch {
            throw APIError.network
        }
        guard let httpResponse = result.response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard httpResponse.isSuccess else {
            throw APIError.server(statusCode: httpResponse.statusCode)
        }
        return result.data
    }

    @concurrent
    nonisolated private static func decode<Response: Decodable & Sendable>(
        _ data: Data
    ) async throws(APIError) -> Response {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }
}
