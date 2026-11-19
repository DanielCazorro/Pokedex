//
//  AppLanguageTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct AppLanguageTests {

    // MARK: Test vars

    let names = ["es": "Planta", "en": "Grass"]

    // MARK: Tests

    @Test(arguments: [("es", "Planta"), ("en", "Grass"), ("fr", "Grass")])
    func preferredValuePicksAppLanguageOrFallsBackToEnglish(code: String, expectedName: String) {
        // Given
        let sut = AppLanguage(code: code)

        // When
        let name = sut.preferredValue(in: names)

        // Then
        #expect(name == expectedName)
    }
}
