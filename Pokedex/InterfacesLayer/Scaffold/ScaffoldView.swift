//
//  ScaffoldView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Base of every screen: puts the content under the navigation title, swaps it for the empty state when there is
/// one, and draws the loading overlay and the snackbar on top.
struct ScaffoldView<Content: View>: View {
    let viewModel: ScaffoldViewModel
    private let content: Content

    init(viewModel: ScaffoldViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }

    var body: some View {
        Group {
            if let emptyState = viewModel.emptyState {
                EmptyStateView(model: emptyState, onButtonClick: viewModel.didEmptyStateButtonClick)
            } else {
                content
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(viewModel.title)
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .overlay(alignment: .bottom) {
            if let snackbar = viewModel.snackbar {
                SnackbarView(model: snackbar)
                    .padding(Spacing.l)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: viewModel.snackbar)
        .task(id: viewModel.snackbar?.id) {
            guard viewModel.snackbar != nil,
                  (try? await Task.sleep(for: SnackbarView.displayDuration)) != nil
            else { return }
            viewModel.hideSnackbar()
        }
    }
}
