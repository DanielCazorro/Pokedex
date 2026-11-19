//
//  DesignSystemSnapshotTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import SnapshotTesting
import SwiftUI
import Testing

extension SnapshotTests {
    @Suite struct DesignSystemSnapshotTests {

        // MARK: Test vars

        /// Never reaches the network: images stay on their placeholder.
        let imageLoader: ImageLoader

        // MARK: Test setup

        init() {
            let transport = HTTPTransportSpy()
            transport.sendSuccess = false
            let diskCache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
            imageLoader = ImageLoader(transport: transport, diskCache: diskCache)
        }

        // MARK: Tests

        @Test func typeChips() {
            // Given
            let view = LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: Spacing.s) {
                ForEach(PokemonType.allCases, id: \.self) { TypeChip(type: $0) }
            }
            .padding()
            .background(.background)

            // When / Then
            assertSnapshot(of: view, as: .component(width: 390, height: 200))
        }

        @Test func pokemonCardGrid() {
            // Given
            let cards = [
                PokemonCardModel(id: 25, name: "Pikachu", primaryType: .electric, secondaryType: nil),
                PokemonCardModel(id: 94, name: "Gengar", primaryType: .ghost, secondaryType: .poison),
                PokemonCardModel(id: 448, name: "Lucario", primaryType: .fighting, secondaryType: .steel),
                PokemonCardModel(id: 175, name: "Togepi", primaryType: .fairy, secondaryType: nil)
            ]
            let view = PokemonCardGrid(cards: cards, onSelect: { _ in })
                .padding(.top, Spacing.l)
                .background(.background)
                .environment(\.imageLoader, imageLoader)

            // When / Then
            assertSnapshot(of: view, as: .component(width: 390, height: 320))
        }
    }
}
