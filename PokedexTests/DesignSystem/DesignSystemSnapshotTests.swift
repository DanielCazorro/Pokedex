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

        @Test func pokemonCards() {
            // Given
            let pikachu = PokemonCardModel(id: 25, name: "Pikachu", primaryType: .electric, secondaryType: nil)
            let gengar = PokemonCardModel(id: 94, name: "Gengar", primaryType: .ghost, secondaryType: .poison)
            let view = LazyVGrid(columns: [GridItem(), GridItem()], spacing: Spacing.m) {
                PokemonCard(model: pikachu)
                PokemonCard(model: gengar)
            }
            .padding()
            .background(.background)
            .environment(\.imageLoader, imageLoader)

            // When / Then
            assertSnapshot(of: view, as: .component(width: 390, height: 170))
        }
    }
}
