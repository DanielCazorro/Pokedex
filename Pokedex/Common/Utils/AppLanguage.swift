//
//  AppLanguage.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

/// The language the app is running in, used to pick the matching text from the API.
nonisolated struct AppLanguage: Sendable {
    static let fallbackCode = "en"
    static let current = AppLanguage(code: Bundle.main.preferredLocalizations.first ?? fallbackCode)

    let code: String

    /// `values` is keyed by API language code ("es", "en"…). Falls back to English when the app language is missing.
    func preferredValue<Value>(in values: [String: Value]) -> Value? {
        values[code] ?? values[Self.fallbackCode]
    }
}
