//
//  AppTestModeTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct AppTestModeTests {

    // MARK: Tests

    @Test func appIsRunningOnTestModeWhenRunningTests() {
        // Given

        // When
        let isTestMode = appIsRunningOnTestMode()

        // Then
        #expect(isTestMode)
    }
}
