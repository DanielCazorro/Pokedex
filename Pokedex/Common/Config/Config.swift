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

    private static let artworkBaseURL = URL(
        staticString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/")

    /// Official artwork only needs the species number, so the list doesn't have to load every Pokémon's detail.
    static func artworkURL(for id: Int) -> URL {
        artworkBaseURL.appending(path: "\(id).png")
    }
}
