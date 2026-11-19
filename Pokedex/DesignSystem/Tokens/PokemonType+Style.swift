//
//  PokemonType+Style.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

extension PokemonType {
    var localizedName: String {
        "pokemonType.\(rawValue)".localized
    }

    var backgroundColor: Color {
        Color(hex: hex)
    }

    /// Black or white, whichever has the higher WCAG contrast ratio against the type color.
    var foregroundColor: Color {
        prefersDarkText ? .black : .white
    }

    var prefersDarkText: Bool {
        let luminance = Self.relativeLuminance(of: hex)
        let contrastWithWhite = 1.05 / (luminance + 0.05)
        let contrastWithBlack = (luminance + 0.05) / 0.05
        return contrastWithBlack > contrastWithWhite
    }

    // MARK: - Private

    private var hex: UInt32 {
        switch self {
        case .normal: 0xA8A77A
        case .fire: 0xEE8130
        case .water: 0x6390F0
        case .electric: 0xF7D02C
        case .grass: 0x7AC74C
        case .ice: 0x96D9D6
        case .fighting: 0xC22E28
        case .poison: 0xA33EA1
        case .ground: 0xE2BF65
        case .flying: 0xA98FF3
        case .psychic: 0xF95587
        case .bug: 0xA6B91A
        case .rock: 0xB6A136
        case .ghost: 0x735797
        case .dragon: 0x6F35FC
        case .dark: 0x705746
        case .steel: 0xB7B7CE
        case .fairy: 0xD685AD
        }
    }

    private static func relativeLuminance(of hex: UInt32) -> Double {
        let channels = [hex >> 16, hex >> 8, hex].map { Double($0 & 0xFF) / 255 }
        let linear = channels.map { $0 <= 0.039_28 ? $0 / 12.92 : pow(($0 + 0.055) / 1.055, 2.4) }
        return 0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]
    }
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255)
    }
}
