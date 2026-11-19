//
//  ScaffoldViewModel.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Observation

/// Base of every screen's ViewModel: title, loading, error snackbar and empty state.
/// Subclasses are `@Observable final class <Feature>ViewModel: ScaffoldViewModel`.
@Observable
class ScaffoldViewModel {
    let title: String
    private(set) var isLoading = false
    private(set) var snackbar: SnackbarModel?
    private(set) var emptyState: EmptyStateModel?

    init(config: ScaffoldConfig) {
        title = config.title
    }

    // MARK: - Overridable events

    /// `async` so a retry can be awaited in tests.
    func didEmptyStateButtonClick() async {}

    // MARK: - State

    func showLoading() {
        isLoading = true
    }

    func hideLoading() {
        isLoading = false
    }

    func showSnackbar(message: String) {
        snackbar = SnackbarModel(message: message)
    }

    func hideSnackbar() {
        snackbar = nil
    }

    func showEmptyState(_ model: EmptyStateModel) {
        emptyState = model
    }

    func hideEmptyState() {
        emptyState = nil
    }
}
