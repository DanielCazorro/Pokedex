//
//  PokemonIndexAPIRepositoryTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import Testing

struct PokemonIndexAPIRepositoryTests {

    // MARK: Test subject

    let sut: PokemonIndexAPIRepository

    // MARK: Test vars

    let transport = HTTPTransportSpy()

    // MARK: Test setup

    init() throws {
        transport.sendResponse = (try Fixture.data(named: "pokemon-index"), 200)
        let cache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
        sut = PokemonIndexAPIRepository(client: URLSessionAPIClient(transport: transport, cache: cache))
    }

    // MARK: Tests

    @Test func getPokemonIndexReusesTheCacheAndRefreshSkipsIt() async throws {
        // Given
        let firstResponse = try await sut.getPokemonIndex()
        transport.sendCalled = false

        // When
        _ = try await sut.getPokemonIndex()
        let usedNetworkForGet = transport.sendCalled
        _ = try await sut.refreshPokemonIndex()

        // Then
        #expect(firstResponse.species.map(\.id) == [1, 25, 1025])
        #expect(!usedNetworkForGet)
        #expect(transport.sendCalled)
    }
}
