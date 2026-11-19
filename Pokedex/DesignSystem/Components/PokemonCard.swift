//
//  PokemonCard.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct PokemonCardModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let primaryType: PokemonType
    let secondaryType: PokemonType?

    var types: [PokemonType] {
        [primaryType] + [secondaryType].compactMap(\.self)
    }

    var formattedNumber: String {
        "#" + id.formatted(.number.precision(.integerLength(3...)).grouping(.never))
    }

    /// Content for the skeleton cards shown while loading (always redacted, never shown as text).
    static let placeholder = PokemonCardModel(id: .zero, name: "Pokémon", primaryType: .normal, secondaryType: nil)
}

struct PokemonCard: View {
    private static let artworkSize: CGFloat = 84
    private static let minHeight: CGFloat = 120

    let model: PokemonCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(model.formattedNumber)
                .font(.pokemonNumber)
                .opacity(0.7)
            Text(model.name)
                .font(.cardTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            ForEach(model.types, id: \.self) { type in
                TypeChip(type: type, style: .onTypeColor(model.primaryType))
            }
        }
        .padding(Spacing.m)
        .frame(maxWidth: .infinity, minHeight: Self.minHeight, alignment: .topLeading)
        .background(alignment: .bottomTrailing) {
            RemoteImage(url: Config.artworkURL(for: model.id))
                .frame(width: Self.artworkSize, height: Self.artworkSize)
                .padding(Spacing.xs)
        }
        .foregroundStyle(model.primaryType.foregroundColor)
        .background(model.primaryType.backgroundColor.gradient, in: .rect(cornerRadius: CornerRadius.card))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview

#Preview {
    LazyVGrid(columns: [GridItem(), GridItem()], spacing: Spacing.m) {
        PokemonCard(model: PokemonCardModel(id: 1, name: "Bulbasaur", primaryType: .grass, secondaryType: .poison))
        PokemonCard(model: PokemonCardModel(id: 25, name: "Pikachu", primaryType: .electric, secondaryType: nil))
        PokemonCard(model: PokemonCardModel(id: 94, name: "Gengar", primaryType: .ghost, secondaryType: .poison))
        PokemonCard(model: PokemonCardModel(id: 1025, name: "Pecharunt", primaryType: .poison, secondaryType: .ghost))
    }
    .padding()
}
