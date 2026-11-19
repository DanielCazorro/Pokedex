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

/// Colors may drift imperceptibly between runs.
private let perceptualPrecision: Float = 0.98
/// Screens with Liquid Glass or a spinner never render two runs identically: the spinner keeps turning and the
/// glass blur behind it varies. Measured worst case is 0.12% of pixels, so 0.5% leaves headroom while a missing
/// text or snackbar still fails.
private let screenPrecision: Float = 0.995

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    /// Draws the key window like the screen does, so Liquid Glass and materials show up. Waits for the glass
    /// appearance animation to finish first.
    static var screen: Self {
        .wait(
            for: 1,
            on: .image(
                drawHierarchyInKeyWindow: true,
                precision: screenPrecision,
                perceptualPrecision: perceptualPrecision,
                layout: .device(config: .iPhone13)))
    }

    static func component(width: CGFloat, height: CGFloat) -> Self {
        .image(
            drawHierarchyInKeyWindow: true,
            perceptualPrecision: perceptualPrecision,
            layout: .fixed(width: width, height: height))
    }
}
