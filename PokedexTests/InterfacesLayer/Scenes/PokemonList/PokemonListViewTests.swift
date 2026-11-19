//
//  PokemonListViewTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import SnapshotTesting
import SwiftUI
import Testing

extension SnapshotTests {
    @Suite struct PokemonListViewTests {

        // MARK: Test vars

        let viewModel: PokemonListViewModel
        let repository = PokemonIndexAPIRepositorySpy()
        let imageLoader: ImageLoader

        // MARK: Test setup

        init() {
            let useCase = PokemonListUseCase(repository: repository, language: AppLanguage(code: "en"))
            viewModel = PokemonListViewModel(useCase: useCase, log: PokemonListLogSpy(), router: Router())
            let transport = HTTPTransportSpy()
            transport.sendSuccess = false
            let diskCache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
            imageLoader = ImageLoader(transport: transport, diskCache: diskCache)
        }

        /// The view's `.task` calls `getPokemonIndex()` again while the snapshot waits: the spy answers the same way.
        func makeView() -> some View {
            NavigationStack {
                PokemonListView(viewModel: viewModel)
            }
            .environment(\.imageLoader, imageLoader)
        }

        // MARK: Tests

        @Test func skeletonWhileLoading() {
            // Given
            repository.getPokemonIndexSuccess = false
            repository.getPokemonIndexError = .cancelled

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }

        @Test func noResultsWithFilters() async {
            // Given
            await viewModel.getPokemonIndex()
            viewModel.selectedType = .dragon

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }

        @Test func networkError() async {
            // Given
            repository.getPokemonIndexSuccess = false
            await viewModel.getPokemonIndex()

            // When / Then
            assertSnapshot(of: makeView(), as: .screen)
        }
    }
}
