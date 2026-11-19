//
//  Int+RomanNumeral.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

extension Int {
    /// Generations are written in Roman numerals ("Generation IV").
    var romanNumeral: String {
        let symbols = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"),
                       (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        var remainder = self
        return symbols.reduce(into: String.empty) { result, symbol in
            while remainder >= symbol.0 {
                result += symbol.1
                remainder -= symbol.0
            }
        }
    }
}
