//
//  RomanNumeralTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct RomanNumeralTests {

    // MARK: Tests

    @Test(arguments: [(1, "I"), (4, "IV"), (9, "IX"), (14, "XIV")])
    func romanNumeralConvertsGenerationNumbers(number: Int, expected: String) {
        // Given

        // When
        let romanNumeral = number.romanNumeral

        // Then
        #expect(romanNumeral == expected)
    }
}
