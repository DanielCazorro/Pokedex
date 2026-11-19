//
//  PokemonListUseCase.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

final class PokemonListUseCase {
    private let repository: PokemonIndexRepository
    private let language: AppLanguage

    init(repository: PokemonIndexRepository, language: AppLanguage = .current) {
        self.repository = repository
        self.language = language
    }

    func getPokemonIndex() async throws(APIError) -> [PokemonSummary] {
        makeSummaries(try await repository.getPokemonIndex())
    }

    func refreshPokemonIndex() async throws(APIError) -> [PokemonSummary] {
        makeSummaries(try await repository.refreshPokemonIndex())
    }

    /// An empty query or a `nil` filter doesn't filter. A numeric query (with or without "#") matches the number.
    func filter(
        _ pokemon: [PokemonSummary], query: String, type: PokemonType?, generation: Int?
    ) -> [PokemonSummary] {
        let normalizedQuery = query.searchNormalized
        let number = Int(normalizedQuery.trimmingPrefix("#"))
        return pokemon.filter { summary in
            let matchesQuery = normalizedQuery.isEmpty
                || summary.id == number
                || summary.searchTerms.contains { $0.contains(normalizedQuery) }
            let matchesType = type.map { $0 == summary.primaryType || $0 == summary.secondaryType } ?? true
            let matchesGeneration = generation.map { $0 == summary.generation } ?? true
            return matchesQuery && matchesType && matchesGeneration
        }
    }

    // MARK: - Private

    private func makeSummaries(_ response: PokemonIndexResponse) -> [PokemonSummary] {
        response.species.compactMap(makeSummary)
    }

    /// Drops species whose types the app doesn't know, so a new type in the API can't break the list.
    private func makeSummary(_ species: PokemonIndexSpeciesResponse) -> PokemonSummary? {
        let types = species.varieties.first?.types.compactMap { PokemonType(rawValue: $0.type.name) } ?? []
        guard let primaryType = types.first else { return nil }
        let names = Dictionary(
            species.names.map { ($0.language.name, $0.name) }, uniquingKeysWith: { first, _ in first })
        return PokemonSummary(
            id: species.id,
            name: language.preferredValue(in: names) ?? species.name.capitalized,
            primaryType: primaryType,
            secondaryType: types.dropFirst().first,
            generation: species.generationId,
            searchTerms: (names.values + [species.name]).map(\.searchNormalized))
    }
}
