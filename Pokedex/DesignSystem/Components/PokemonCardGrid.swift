//
//  PokemonCardGrid.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Two-column grid of Pokémon cards. Put it inside a `ScrollView`.
struct PokemonCardGrid: View {
    static let columns = [GridItem(spacing: Spacing.m), GridItem(spacing: Spacing.m)]

    let cards: [PokemonCardModel]
    let onSelect: (Int) -> Void

    var body: some View {
        LazyVGrid(columns: Self.columns, spacing: Spacing.m) {
            ForEach(cards) { card in
                Button {
                    onSelect(card.id)
                } label: {
                    PokemonCard(model: card)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.l)
        .padding(.bottom, Spacing.l)
    }
}

/// Placeholder grid while the cards load. It's a separate grid on purpose: sharing one `LazyVGrid` with the real
/// cards, the skeleton cells (ids 0-11) were reused for the first Pokémon.
struct PokemonCardSkeletonGrid: View {
    private static let count = 12

    var body: some View {
        LazyVGrid(columns: PokemonCardGrid.columns, spacing: Spacing.m) {
            ForEach(0..<Self.count, id: \.self) { _ in
                PokemonCard(model: .placeholder)
            }
        }
        .redacted(reason: .placeholder)
        .padding(.horizontal, Spacing.l)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        PokemonCardGrid(
            cards: [
                PokemonCardModel(id: 1, name: "Bulbasaur", primaryType: .grass, secondaryType: .poison),
                PokemonCardModel(id: 4, name: "Charmander", primaryType: .fire, secondaryType: nil),
                PokemonCardModel(id: 7, name: "Squirtle", primaryType: .water, secondaryType: nil),
                PokemonCardModel(id: 25, name: "Pikachu", primaryType: .electric, secondaryType: nil)
            ],
            onSelect: { _ in })
        PokemonCardSkeletonGrid()
    }
}
