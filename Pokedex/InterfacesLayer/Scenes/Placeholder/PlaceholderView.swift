//
//  PlaceholderView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Stands in for the screens of later phases.
struct PlaceholderView: View {
    @State private var viewModel: ScaffoldViewModel

    init(viewModel: ScaffoldViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScaffoldView(viewModel: viewModel) {
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PlaceholderView.getView(title: "Pokédex")
    }
}

extension PlaceholderView {
    static func getView(title: String) -> PlaceholderView {
        let config = ScaffoldConfig.Builder()
            .setTitle(title)
            .build()
        let viewModel = ScaffoldViewModel(config: config)
        viewModel.showEmptyState(
            EmptyStateModel(
                title: "placeholder.title".localized,
                message: "placeholder.message".localized,
                systemImage: "hammer",
                buttonTitle: nil))
        return PlaceholderView(viewModel: viewModel)
    }
}
