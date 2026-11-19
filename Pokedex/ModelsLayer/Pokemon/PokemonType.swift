//
//  PokemonType.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

/// The 18 types, with the raw values the API uses.
nonisolated enum PokemonType: String, CaseIterable, Sendable {
    case normal, fire, water, electric, grass, ice, fighting, poison, ground
    case flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy
}
