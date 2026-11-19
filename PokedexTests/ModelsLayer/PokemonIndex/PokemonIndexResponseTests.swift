//
//  PokemonIndexResponseTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import Testing

struct PokemonIndexResponseTests {

    // MARK: Test vars

    let transport = HTTPTransportSpy()

    // MARK: Tests

    @Test func decodesRealIndexResponse() async throws {
        // Given
        transport.sendResponse = (try Fixture.data(named: "pokemon-index"), 200)
        let cache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
        let client = URLSessionAPIClient(transport: transport, cache: cache)
        let request = RequestBuilder(baseURL: Config.graphQLURL)
            .set(method: .post)
            .set(body: GraphQLRequest.pokemonIndex)
            .build()

        // When
        let response: GraphQLResponse<PokemonIndexResponse> = try await client.execute(request)

        // Then
        let pikachu = try #require(response.data.species.first { $0.id == 25 })
        #expect(response.data.species.map(\.id) == [1, 25, 1025])
        #expect(pikachu.name == "pikachu")
        #expect(pikachu.generationId == 1)
        #expect(pikachu.names.map(\.language.name).sorted() == ["en", "es"])
        #expect(pikachu.varieties.first?.types.map(\.type.name) == ["electric"])
    }
}
