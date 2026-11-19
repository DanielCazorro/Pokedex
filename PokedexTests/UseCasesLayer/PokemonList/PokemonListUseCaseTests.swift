//
//  PokemonListUseCaseTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct PokemonListUseCaseTests {

    // MARK: Test subject

    let sut: PokemonListUseCase

    // MARK: Test vars

    let repository = PokemonIndexAPIRepositorySpy()

    // MARK: Test setup

    init() {
        sut = PokemonListUseCase(repository: repository, language: AppLanguage(code: "es"))
    }

    // MARK: Tests

    @Test func getPokemonIndexMapsSpeciesInAppLanguageAndDropsUnknownTypes() async throws {
        // Given
        repository.getPokemonIndexResponse = PokemonIndexResponse(species: [
            .sample(id: 669, name: "flabebe", english: "Flabébé", spanish: "Flabébé ES", generation: 6,
                    types: ["fairy"]),
            .sample(id: 999, name: "unknown", english: "Unknown", spanish: "Desconocido", types: ["stellar"])
        ])

        // When
        let pokemon = try await sut.getPokemonIndex()

        // Then
        let flabebe = try #require(pokemon.first)
        #expect(pokemon.count == 1)
        #expect(flabebe.name == "Flabébé ES")
        #expect(flabebe.primaryType == .fairy)
        #expect(flabebe.secondaryType == nil)
        #expect(flabebe.generation == 6)
        #expect(Set(flabebe.searchTerms) == ["flabebe es", "flabebe"])
    }

    @Test func refreshPokemonIndexAsksTheRepositoryToRefresh() async throws {
        // Given

        // When
        let pokemon = try await sut.refreshPokemonIndex()

        // Then
        #expect(repository.refreshPokemonIndexCalled)
        #expect(!repository.getPokemonIndexCalled)
        #expect(pokemon.count == PokemonIndexResponse.sample.species.count)
    }

    @Test(arguments: [
        FilterCase(query: "", expectedIds: [1, 4, 7, 25, 94, 150, 152, 175, 448, 1025]),
        FilterCase(query: "  PIKA ", expectedIds: [25]),
        FilterCase(query: "25", expectedIds: [25]),
        FilterCase(query: "#150", expectedIds: [150]),
        FilterCase(query: "", type: .poison, expectedIds: [1, 94, 1025]),
        FilterCase(query: "", generation: 2, expectedIds: [152, 175]),
        FilterCase(query: "", type: .grass, generation: 2, expectedIds: [152]),
        FilterCase(query: "char", type: .water, expectedIds: [])
    ])
    func filterCombinesQueryTypeAndGeneration(_ filterCase: FilterCase) async throws {
        // Given
        let pokemon = try await sut.getPokemonIndex()

        // When
        let filtered = sut.filter(
            pokemon, query: filterCase.query, type: filterCase.type, generation: filterCase.generation)

        // Then
        #expect(filtered.map(\.id) == filterCase.expectedIds)
    }
}

// MARK: - Helpers

nonisolated struct FilterCase: Sendable, CustomTestStringConvertible {
    let query: String
    var type: PokemonType?
    var generation: Int?
    let expectedIds: [Int]

    var testDescription: String {
        "query: \"\(query)\", type: \(type?.rawValue ?? "any"), generation: \(generation.map(String.init) ?? "any")"
    }
}
