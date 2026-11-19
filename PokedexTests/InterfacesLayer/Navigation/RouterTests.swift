//
//  RouterTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct RouterTests {

    // MARK: Test subject

    let sut = Router()

    // MARK: Tests

    @Test func navigateAppendsRouteToPath() {
        // Given
        sut.navigate(to: .pokemonDetail(id: 1))

        // When
        sut.navigate(to: .pokemonDetail(id: 25))

        // Then
        #expect(sut.path == [.pokemonDetail(id: 1), .pokemonDetail(id: 25)])
    }
}
