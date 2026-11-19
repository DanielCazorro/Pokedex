//
//  URLSessionAPIClientTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import Testing

struct URLSessionAPIClientTests {

    // MARK: Test subject

    let sut: URLSessionAPIClient

    // MARK: Test vars

    let transport = HTTPTransportSpy()
    let cache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
    let builder = RequestBuilder(baseURL: URL(staticString: "https://example.com/api/")).set(path: "pokemon/25")
    let cachedJSON = Data(#"{"name":"cached"}"#.utf8)
    let networkJSON = Data(#"{"name":"network"}"#.utf8)

    // MARK: Test setup

    init() {
        sut = URLSessionAPIClient(transport: transport, cache: cache)
    }

    func cacheKey(for request: APIRequest) throws -> String {
        try request.urlRequest().cacheKey
    }

    // MARK: Tests

    @Test func executeDecodesSnakeCaseResponse() async throws {
        // Given
        transport.sendResponse = (Data(#"{"name":"pikachu","base_experience":112}"#.utf8), 200)

        // When
        let response: SampleResponse = try await sut.execute(builder.build())

        // Then
        #expect(response == SampleResponse(name: "pikachu", baseExperience: 112))
    }

    @Test(arguments: [
        FailureCase(data: Data("{}".utf8), statusCode: 500, expectedError: .server(statusCode: 500)),
        FailureCase(data: Data("not json".utf8), expectedError: .invalidResponse),
        FailureCase(transportError: URLError(.notConnectedToInternet), expectedError: .network),
        FailureCase(transportError: URLError(.cancelled), expectedError: .cancelled)
    ])
    func executeMapsFailures(_ failureCase: FailureCase) async {
        // Given
        transport.sendResponse = (failureCase.data, failureCase.statusCode)
        if let transportError = failureCase.transportError {
            transport.sendSuccess = false
            transport.sendError = transportError
        }

        // When / Then
        await #expect(throws: failureCase.expectedError) {
            _ = try await sut.execute(builder.build()) as SampleResponse
        }
    }

    @Test func executeReturnsFreshCacheWithoutCallingNetwork() async throws {
        // Given
        let request = builder.set(cacheMaxAge: 60).build()
        await cache.store(cachedJSON, for: try cacheKey(for: request))

        // When
        let response: SampleResponse = try await sut.execute(request)

        // Then
        #expect(response.name == "cached")
        #expect(!transport.sendCalled)
    }

    @Test func executeRefreshesStaleCache() async throws {
        // Given
        let request = builder.set(cacheMaxAge: .zero).build()
        let key = try cacheKey(for: request)
        await cache.store(cachedJSON, for: key)
        transport.sendResponse = (networkJSON, 200)

        // When
        let response: SampleResponse = try await sut.execute(request)

        // Then
        #expect(response.name == "network")
        #expect(await cache.entry(for: key)?.data == networkJSON)
    }

    @Test func executeReturnsStaleCacheWhenNetworkFails() async throws {
        // Given
        let request = builder.set(cacheMaxAge: .zero).build()
        await cache.store(cachedJSON, for: try cacheKey(for: request))
        transport.sendSuccess = false

        // When
        let response: SampleResponse = try await sut.execute(request)

        // Then
        #expect(response.name == "cached")
    }

    @Test func executeThrowsNetworkErrorWhenOfflineWithoutCache() async {
        // Given
        let request = builder.set(cacheMaxAge: 60).build()
        transport.sendSuccess = false

        // When / Then
        await #expect(throws: APIError.network) {
            _ = try await sut.execute(request) as SampleResponse
        }
    }

    @Test func executeDoesNotCacheResponsesThatFailToDecode() async throws {
        // Given
        let request = builder.set(cacheMaxAge: 60).build()
        transport.sendResponse = (Data("not json".utf8), 200)

        // When
        await #expect(throws: APIError.invalidResponse) {
            _ = try await sut.execute(request) as SampleResponse
        }

        // Then
        #expect(await cache.entry(for: try cacheKey(for: request)) == nil)
    }
}

// MARK: - Helpers

nonisolated private struct SampleResponse: Decodable, Sendable, Equatable {
    var name: String
    var baseExperience: Int?
}

nonisolated struct FailureCase: Sendable, CustomTestStringConvertible {
    var data = Data()
    var statusCode = 200
    var transportError: URLError?
    let expectedError: APIError

    var testDescription: String {
        "\(expectedError)"
    }
}
