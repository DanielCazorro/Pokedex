//
//  PokemonListLogUseCase.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

protocol PokemonListLogLogic {
    func logScreenView()
    func logPokemonSelected(id: Int)
}

final class PokemonListLogUseCase: PokemonListLogLogic {
    private enum Events {
        static let screenName = "pokemon_list"
        static let pokemonSelected = "pokemon_selected"
        static let idParameter = "pokemon_id"
    }

    private let tracker: AnalyticsTracker

    init(tracker: AnalyticsTracker = OSLogTracker.shared) {
        self.tracker = tracker
    }

    func logScreenView() {
        tracker.logScreenView(Events.screenName)
    }

    func logPokemonSelected(id: Int) {
        tracker.logEvent(Events.pokemonSelected, parameters: [Events.idParameter: "\(id)"])
    }
}
