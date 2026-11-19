//
//  AnalyticsTracker.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation
import OSLog

/// What every `<Feature>LogUseCase` sends its events to.
protocol AnalyticsTracker {
    func logScreenView(_ screenName: String)
    func logEvent(_ name: String, parameters: [String: String])
}

/// Writes the events to the unified log (filter by the "Analytics" category in Console).
final class OSLogTracker: AnalyticsTracker {
    static let shared = OSLogTracker()

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Pokedex", category: "Analytics")

    func logScreenView(_ screenName: String) {
        logger.info("screen_view \(screenName, privacy: .public)")
    }

    func logEvent(_ name: String, parameters: [String: String]) {
        logger.info("\(name, privacy: .public) \(parameters.description, privacy: .public)")
    }
}
