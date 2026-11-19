//
//  PokemonListViewModelTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Testing

struct PokemonListViewModelTests {

    // MARK: Test subject

    let sut: PokemonListViewModel

    // MARK: Test vars

    let repository = PokemonIndexAPIRepositorySpy()
    let log = PokemonListLogSpy()
    let router = Router()
    let sampleCount = PokemonIndexResponse.sample.species.count

    // MARK: Test setup

    init() {
        let useCase = PokemonListUseCase(repository: repository, language: AppLanguage(code: "en"))
        sut = PokemonListViewModel(useCase: useCase, log: log, router: router)
    }

    // MARK: Tests

    @Test func initShowsSkeleton() {
        // Given

        // When

        // Then
        #expect(sut.isShowingSkeleton)
        #expect(sut.cards.isEmpty)
        #expect(sut.emptyState == nil)
    }

    @Test func getPokemonIndexShowsCardsAndItsGenerations() async {
        // Given

        // When
        await sut.getPokemonIndex()

        // Then
        #expect(sut.cards.count == sampleCount)
        #expect(sut.generations == [1, 2, 4, 9])
        #expect(!sut.isShowingSkeleton)
    }

    @Test func getPokemonIndexLoadsOnlyOnce() async {
        // Given
        await sut.getPokemonIndex()
        repository.getPokemonIndexCalled = false

        // When
        await sut.getPokemonIndex()

        // Then
        #expect(!repository.getPokemonIndexCalled)
    }

    @Test(arguments: [
        (APIError.network, "pokemonList.error.network.title", "wifi.slash"),
        (APIError.server(statusCode: 500), "pokemonList.error.generic.title", "exclamationmark.triangle")
    ])
    func getPokemonIndexFailureShowsErrorWithRetry(error: APIError, titleKey: String, systemImage: String) async {
        // Given
        repository.getPokemonIndexSuccess = false
        repository.getPokemonIndexError = error

        // When
        await sut.getPokemonIndex()

        // Then
        #expect(sut.emptyState?.title == titleKey.localized)
        #expect(sut.emptyState?.systemImage == systemImage)
        #expect(sut.emptyState?.buttonTitle == "common.retry".localized)
        #expect(!sut.isShowingSkeleton)
    }

    @Test func getPokemonIndexCancelledKeepsSkeleton() async {
        // Given
        repository.getPokemonIndexSuccess = false
        repository.getPokemonIndexError = .cancelled

        // When
        await sut.getPokemonIndex()

        // Then
        #expect(sut.emptyState == nil)
        #expect(sut.isShowingSkeleton)
    }

    @Test func retryAfterErrorLoadsTheIndex() async {
        // Given
        repository.getPokemonIndexSuccess = false
        await sut.getPokemonIndex()
        repository.getPokemonIndexSuccess = true

        // When
        await sut.didEmptyStateButtonClick()

        // Then
        #expect(sut.emptyState == nil)
        #expect(sut.cards.count == sampleCount)
    }

    @Test func refreshPokemonIndexReplacesTheCards() async {
        // Given
        await sut.getPokemonIndex()
        repository.refreshPokemonIndexResponse = PokemonIndexResponse(
            species: Array(PokemonIndexResponse.sample.species.prefix(2)))

        // When
        await sut.refreshPokemonIndex()

        // Then
        #expect(repository.refreshPokemonIndexCalled)
        #expect(sut.cards.map(\.id) == [1, 4])
    }

    @Test func refreshPokemonIndexFailureKeepsCardsAndShowsSnackbar() async {
        // Given
        await sut.getPokemonIndex()
        repository.refreshPokemonIndexSuccess = false

        // When
        await sut.refreshPokemonIndex()

        // Then
        #expect(sut.cards.count == sampleCount)
        #expect(sut.snackbar?.message == "pokemonList.refreshError".localized)
    }

    @Test func searchWithoutResultsShowsEmptyStateWithoutButton() async {
        // Given
        await sut.getPokemonIndex()

        // When
        sut.searchText = "missingno"

        // Then
        #expect(sut.emptyState?.title == "pokemonList.noResults.title".localized)
        #expect(sut.emptyState?.buttonTitle == nil)
    }

    @Test func clearFiltersFromEmptyStateShowsCardsAgain() async {
        // Given
        await sut.getPokemonIndex()
        sut.selectedType = .dragon
        let buttonTitle = sut.emptyState?.buttonTitle

        // When
        await sut.didEmptyStateButtonClick()

        // Then
        #expect(buttonTitle == "pokemonList.filter.clear".localized)
        #expect(sut.selectedType == nil)
        #expect(sut.emptyState == nil)
        #expect(sut.cards.count == sampleCount)
    }

    @Test func navigateToDetailPushesRouteAndLogsIt() {
        // Given

        // When
        sut.navigateToDetail(id: 25)

        // Then
        #expect(router.path == [.pokemonDetail(id: 25)])
        #expect(log.logPokemonSelectedCalled)
    }

    @Test func logScreenViewLogsIt() {
        // Given

        // When
        sut.logScreenView()

        // Then
        #expect(log.logScreenViewCalled)
    }
}
