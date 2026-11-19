//
//  TypeChip.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct TypeChip: View {
    enum Style {
        /// The type's own color, for neutral backgrounds.
        case filled
        /// Over a background painted with another type's color (a card): same text color as that background, on a
        /// tint that keeps its contrast.
        case onTypeColor(PokemonType)
    }

    let type: PokemonType
    var style = Style.filled

    var body: some View {
        Text(type.localizedName)
            .font(.chip)
            .padding(.horizontal, Spacing.s)
            .padding(.vertical, Spacing.xs)
            .foregroundStyle(foreground)
            .background(background, in: .capsule)
    }

    private var foreground: Color {
        switch style {
        case .filled: type.foregroundColor
        case .onTypeColor(let backgroundType): backgroundType.foregroundColor
        }
    }

    private var background: Color {
        switch style {
        case .filled: type.backgroundColor
        case .onTypeColor(let backgroundType):
            if backgroundType.prefersDarkText {
                .white.opacity(0.35)
            } else {
                .black.opacity(0.2)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: Spacing.s) {
        ForEach(PokemonType.allCases, id: \.self) { TypeChip(type: $0) }
    }
    .padding()
}
