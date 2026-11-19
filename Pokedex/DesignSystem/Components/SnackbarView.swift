//
//  SnackbarView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct SnackbarModel: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

/// Error message shown at the bottom of a screen.
struct SnackbarView: View {
    static let displayDuration = Duration.seconds(4)

    let model: SnackbarModel

    var body: some View {
        Label(model.message, systemImage: "exclamationmark.triangle.fill")
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, Spacing.l)
            .padding(.vertical, Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.tint(.red.opacity(0.35)), in: .rect(cornerRadius: CornerRadius.card))
            .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Preview

#Preview {
    SnackbarView(model: SnackbarModel(message: "Couldn't load the Pokédex"))
        .padding()
}
