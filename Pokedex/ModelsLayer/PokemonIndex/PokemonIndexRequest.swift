//
//  PokemonIndexRequest.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

extension GraphQLRequest {
    /// Every species in a single request: Spanish and English names, generation and the default variety's types.
    /// The aliases keep the JSON keys in line with `PokemonIndexResponse`.
    static let pokemonIndex = GraphQLRequest(query: """
        query PokemonIndex {
          species: pokemonspecies(order_by: {id: asc}) {
            id
            name
            generationId: generation_id
            names: pokemonspeciesnames(where: {language: {name: {_in: ["en", "es"]}}}) {
              name
              language {
                name
              }
            }
            varieties: pokemons(where: {is_default: {_eq: true}}) {
              types: pokemontypes(order_by: {slot: asc}) {
                type {
                  name
                }
              }
            }
          }
        }
        """)
}
