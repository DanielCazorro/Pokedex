//
//  PokemonIndexResponse.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

nonisolated struct PokemonIndexResponse: Decodable, Sendable {
    let species: [PokemonIndexSpeciesResponse]
}

nonisolated struct PokemonIndexSpeciesResponse: Decodable, Sendable {
    let id: Int
    let name: String
    let generationId: Int
    let names: [PokemonIndexNameResponse]
    let varieties: [PokemonIndexVarietyResponse]
}

nonisolated struct PokemonIndexNameResponse: Decodable, Sendable {
    let name: String
    let language: NamedResponse
}

nonisolated struct PokemonIndexVarietyResponse: Decodable, Sendable {
    let types: [PokemonIndexTypeResponse]
}

nonisolated struct PokemonIndexTypeResponse: Decodable, Sendable {
    let type: NamedResponse
}

nonisolated struct NamedResponse: Decodable, Sendable {
    let name: String
}
