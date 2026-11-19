//
//  EmptyStateView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct EmptyStateModel: Equatable {
    let title: String
    let message: String
    let systemImage: String
    /// No button when there's nothing the user can do (e.g. a search without results).
    let buttonTitle: String?
}

struct EmptyStateView: View {
    let model: EmptyStateModel
    let onButtonClick: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(model.title, systemImage: model.systemImage)
        } description: {
            Text(model.message)
        } actions: {
            if let buttonTitle = model.buttonTitle {
                Button(buttonTitle, action: onButtonClick)
                    .buttonStyle(.glassProminent)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView(
        model: EmptyStateModel(
            title: "No connection",
            message: "Check your connection and try again.",
            systemImage: "wifi.slash",
            buttonTitle: "Retry"),
        onButtonClick: {})
}
