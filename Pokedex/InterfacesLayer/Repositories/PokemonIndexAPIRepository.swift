//
//  PokemonIndexAPIRepository.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

final class PokemonIndexAPIRepository: PokemonIndexRepository {
    private let client: APIClient

    init(client: APIClient = URLSessionAPIClient()) {
        self.client = client
    }

    func getPokemonIndex() async throws(APIError) -> PokemonIndexResponse {
        try await execute(cacheMaxAge: Config.indexCacheMaxAge)
    }

    func refreshPokemonIndex() async throws(APIError) -> PokemonIndexResponse {
        try await execute(cacheMaxAge: .zero)
    }

    private func execute(cacheMaxAge: TimeInterval) async throws(APIError) -> PokemonIndexResponse {
        let request = RequestBuilder(baseURL: Config.graphQLURL)
            .set(method: .post)
            .set(body: GraphQLRequest.pokemonIndex)
            .set(cacheMaxAge: cacheMaxAge)
            .build()
        let response: GraphQLResponse<PokemonIndexResponse> = try await client.execute(request)
        return response.data
    }
}

#if DEBUG
final class PokemonIndexAPIRepositorySpy: PokemonIndexRepository {
    var getPokemonIndexCalled = false
    var getPokemonIndexSuccess = true
    var getPokemonIndexResponse = PokemonIndexResponse.sample
    var getPokemonIndexError = APIError.network

    func getPokemonIndex() async throws(APIError) -> PokemonIndexResponse {
        getPokemonIndexCalled = true
        guard getPokemonIndexSuccess else { throw getPokemonIndexError }
        return getPokemonIndexResponse
    }

    var refreshPokemonIndexCalled = false
    var refreshPokemonIndexSuccess = true
    var refreshPokemonIndexResponse = PokemonIndexResponse.sample
    var refreshPokemonIndexError = APIError.network

    func refreshPokemonIndex() async throws(APIError) -> PokemonIndexResponse {
        refreshPokemonIndexCalled = true
        guard refreshPokemonIndexSuccess else { throw refreshPokemonIndexError }
        return refreshPokemonIndexResponse
    }
}

extension PokemonIndexResponse {
    /// Real names and types from the API, for previews and tests.
    static let sample = PokemonIndexResponse(species: [
        .sample(id: 1, name: "bulbasaur", english: "Bulbasaur", spanish: "Bulbasaur", types: ["grass", "poison"]),
        .sample(id: 4, name: "charmander", english: "Charmander", spanish: "Charmander", types: ["fire"]),
        .sample(id: 7, name: "squirtle", english: "Squirtle", spanish: "Squirtle", types: ["water"]),
        .sample(id: 25, name: "pikachu", english: "Pikachu", spanish: "Pikachu", types: ["electric"]),
        .sample(id: 94, name: "gengar", english: "Gengar", spanish: "Gengar", types: ["ghost", "poison"]),
        .sample(id: 150, name: "mewtwo", english: "Mewtwo", spanish: "Mewtwo", types: ["psychic"]),
        .sample(id: 152, name: "chikorita", english: "Chikorita", spanish: "Chikorita", generation: 2,
                types: ["grass"]),
        .sample(id: 175, name: "togepi", english: "Togepi", spanish: "Togepi", generation: 2, types: ["fairy"]),
        .sample(id: 448, name: "lucario", english: "Lucario", spanish: "Lucario", generation: 4,
                types: ["fighting", "steel"]),
        .sample(id: 1025, name: "pecharunt", english: "Pecharunt", spanish: "Pecharunt", generation: 9,
                types: ["poison", "ghost"])
    ])
}

extension PokemonIndexSpeciesResponse {
    static func sample(
        id: Int, name: String, english: String, spanish: String, generation: Int = 1, types: [String]
    ) -> PokemonIndexSpeciesResponse {
        let typeResponses = types.map { PokemonIndexTypeResponse(type: NamedResponse(name: $0)) }
        return PokemonIndexSpeciesResponse(
            id: id,
            name: name,
            generationId: generation,
            names: [
                PokemonIndexNameResponse(name: spanish, language: NamedResponse(name: "es")),
                PokemonIndexNameResponse(name: english, language: NamedResponse(name: "en"))
            ],
            varieties: [PokemonIndexVarietyResponse(types: typeResponses)])
    }
}
#endif
