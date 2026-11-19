//
//  ScaffoldViewTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import SnapshotTesting
import SwiftUI
import Testing

extension SnapshotTests {
    @Suite struct ScaffoldViewTests {

        // MARK: Test vars

        let viewModel = ScaffoldViewModel(config: ScaffoldConfig.Builder().setTitle("Title").build())

        // MARK: Test setup

        func makeView() -> some View {
            NavigationStack {
                ScaffoldView(viewModel: viewModel) {
                    Text("Content")
                }
            }
        }

        // MARK: Tests

        @Test func loading() {
            // Given
            viewModel.showLoading()

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }

        @Test func emptyStateWithButton() {
            // Given
            let emptyState = EmptyStateModel(
                title: "No connection", message: "Try again.", systemImage: "wifi.slash", buttonTitle: "Retry")
            viewModel.showEmptyState(emptyState)

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }

        @Test func snackbar() {
            // Given
            viewModel.showSnackbar(message: "Couldn't load the Pokédex")

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }
    }
}
