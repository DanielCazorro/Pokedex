//
//  PokemonCardModelTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct PokemonCardModelTests {

    // MARK: Tests

    @Test func singleTypePokemonHasPaddedNumberAndOneType() {
        // Given
        let sut = PokemonCardModel(id: 25, name: "Pikachu", primaryType: .electric, secondaryType: nil)

        // When
        let number = sut.formattedNumber
        let types = sut.types

        // Then
        #expect(number == "#025")
        #expect(types == [.electric])
    }

    @Test func dualTypePokemonKeepsFourDigitNumberAndBothTypes() {
        // Given
        let sut = PokemonCardModel(id: 1025, name: "Pecharunt", primaryType: .poison, secondaryType: .ghost)

        // When
        let number = sut.formattedNumber
        let types = sut.types

        // Then
        #expect(number == "#1025")
        #expect(types == [.poison, .ghost])
    }
}
