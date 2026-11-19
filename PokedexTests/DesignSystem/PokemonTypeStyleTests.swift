//
//  PokemonTypeStyleTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct PokemonTypeStyleTests {

    // MARK: Tests

    @Test(arguments: [(PokemonType.electric, true), (.ice, true), (.ghost, false), (.fighting, false)])
    func prefersDarkTextOnlyOnLightColors(type: PokemonType, expectedDarkText: Bool) {
        // Given

        // When
        let prefersDarkText = type.prefersDarkText

        // Then
        #expect(prefersDarkText == expectedDarkText)
    }
}
