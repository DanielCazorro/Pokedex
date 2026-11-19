//
//  APIRequestTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import Testing

struct APIRequestTests {

    // MARK: Test vars

    let baseURL = URL(staticString: "https://example.com/api/")

    // MARK: Tests

    @Test func urlRequestForGetHasPathAndNoBody() throws {
        // Given
        let request = RequestBuilder(baseURL: baseURL).set(path: "pokemon/25").build()

        // When
        let urlRequest = try request.urlRequest()

        // Then
        #expect(urlRequest.url?.absoluteString == "https://example.com/api/pokemon/25")
        #expect(urlRequest.httpMethod == "GET")
        #expect(urlRequest.httpBody == nil)
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == nil)
    }

    @Test func urlRequestForPostEncodesBodyAsJSON() throws {
        // Given
        let request = RequestBuilder(baseURL: baseURL)
            .set(method: .post)
            .set(body: GraphQLRequest(query: "{ species }"))
            .build()

        // When
        let urlRequest = try request.urlRequest()

        // Then
        #expect(urlRequest.httpMethod == "POST")
        #expect(urlRequest.httpBody == Data(#"{"query":"{ species }"}"#.utf8))
        #expect(urlRequest.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test func cacheKeyChangesWithBody() throws {
        // Given
        let builder = RequestBuilder(baseURL: baseURL).set(method: .post)

        // When
        let firstKey = try builder.set(body: GraphQLRequest(query: "{ a }")).build().urlRequest().cacheKey
        let secondKey = try builder.set(body: GraphQLRequest(query: "{ b }")).build().urlRequest().cacheKey

        // Then
        #expect(firstKey != secondKey)
    }
}
