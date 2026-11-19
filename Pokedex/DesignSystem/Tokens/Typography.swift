//
//  Typography.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Rounded system fonts on top of the Dynamic Type text styles.
extension Font {
    static let cardTitle = Font.system(.headline, design: .rounded, weight: .bold)
    static let pokemonNumber = Font.system(.caption, design: .rounded, weight: .semibold).monospacedDigit()
    static let chip = Font.system(.caption2, design: .rounded, weight: .semibold)
}
