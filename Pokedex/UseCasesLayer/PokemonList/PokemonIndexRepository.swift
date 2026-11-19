//
//  PokemonIndexRepository.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

protocol PokemonIndexRepository {
    /// Returns the cached index while it's fresh.
    func getPokemonIndex() async throws(APIError) -> PokemonIndexResponse
    /// Skips the cache and asks the API again (pull to refresh).
    func refreshPokemonIndex() async throws(APIError) -> PokemonIndexResponse
}
