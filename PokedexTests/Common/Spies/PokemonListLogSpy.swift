//
//  PokemonListLogSpy.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

final class PokemonListLogSpy: PokemonListLogLogic {
    var logScreenViewCalled = false
    var logPokemonSelectedCalled = false

    func logScreenView() {
        logScreenViewCalled = true
    }

    func logPokemonSelected(id: Int) {
        logPokemonSelectedCalled = true
    }
}
