//
//  Config.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

enum Config {
    static let graphQLURL = URL(staticString: "https://graphql.pokeapi.co/v1beta2")
    /// The species list only changes when new Pokémon come out.
    static let indexCacheMaxAge: TimeInterval = 7 * 24 * 60 * 60
}
