//
//  String+Localized.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

extension String {
    /// Looks the string up as a key in `Localizable.xcstrings`.
    var localized: String {
        String(localized: LocalizationValue(self))
    }
}
