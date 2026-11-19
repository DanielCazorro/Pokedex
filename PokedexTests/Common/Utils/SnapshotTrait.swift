//
//  SnapshotTrait.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation
import SnapshotTesting
import SwiftUI
import Testing

/// Parent of every snapshot suite (nest them with `extension SnapshotTests`). Snapshots draw in the shared key
/// window, so they must run one at a time; and they only match on the simulator they were recorded with, so CI
/// skips them (`SKIP_SNAPSHOTS`).
@Suite(.localOnly, .serialized)
enum SnapshotTests {}

extension Trait where Self == ConditionTrait {
    static var localOnly: Self {
        .enabled(if: ProcessInfo.processInfo.environment["SKIP_SNAPSHOTS"] == nil, "Snapshots run locally only")
    }
}

/// Colors drift slightly between runs (up to ~5/255 per channel, invisible to the eye).
private let perceptualPrecision: Float = 0.97
/// Components have no glass or animation: only a handful of pixels may differ.
private let componentPrecision: Float = 0.999
/// Screens with Liquid Glass (navigation bar, search field, buttons) or a spinner never render two runs identically:
/// the glass softly reflects whatever scrolls under it. Those changes are subtle but spread over the whole bar, so
/// screens accept a wider color difference and 1% of pixels beyond it. A missing title, card or snackbar still fails.
private let screenPerceptualPrecision: Float = 0.95
private let screenPrecision: Float = 0.99

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    /// Draws the key window like the screen does, so Liquid Glass and materials show up. Waits for the glass
    /// appearance animation to finish first.
    static var screen: Self {
        .wait(
            for: 1,
            on: .image(
                drawHierarchyInKeyWindow: true,
                precision: screenPrecision,
                perceptualPrecision: screenPerceptualPrecision,
                layout: .device(config: .iPhone13)))
    }

    static func component(width: CGFloat, height: CGFloat) -> Self {
        .image(
            drawHierarchyInKeyWindow: true,
            precision: componentPrecision,
            perceptualPrecision: perceptualPrecision,
            layout: .fixed(width: width, height: height))
    }
}
