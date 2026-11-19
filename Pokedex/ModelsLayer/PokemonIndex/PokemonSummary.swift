//
//  PokemonSummary.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

/// A species as the Pokédex list shows it.
nonisolated struct PokemonSummary: Equatable, Sendable {
    let id: Int
    /// In the app language.
    let name: String
    let primaryType: PokemonType
    let secondaryType: PokemonType?
    let generation: Int
    /// Every known name (all languages and the API slug), already normalized with `String.searchNormalized`.
    let searchTerms: [String]
}
