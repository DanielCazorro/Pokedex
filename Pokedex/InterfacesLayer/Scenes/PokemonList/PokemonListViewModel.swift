//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Observation

@Observable
final class PokemonListViewModel: ScaffoldViewModel {
    private enum EmptyStateAction {
        case retry
        case clearFilters
    }

    private let useCase: PokemonListUseCase
    private let log: PokemonListLogLogic
    private let router: Router
    private var pokemon: [PokemonSummary] = []
    private var emptyStateAction: EmptyStateAction?

    var searchText = String.empty {
        didSet { updateNoResultsState() }
    }
    var selectedType: PokemonType? {
        didSet { updateNoResultsState() }
    }
    var selectedGeneration: Int? {
        didSet { updateNoResultsState() }
    }

    var cards: [PokemonCardModel] {
        useCase.filter(pokemon, query: searchText, type: selectedType, generation: selectedGeneration).map { summary in
            PokemonCardModel(
                id: summary.id,
                name: summary.name,
                primaryType: summary.primaryType,
                secondaryType: summary.secondaryType)
        }
    }

    /// Nothing loaded and no error yet: also true on the very first frame, before `getPokemonIndex()` starts.
    var isShowingSkeleton: Bool {
        pokemon.isEmpty && emptyState == nil
    }

    var hasActiveFilters: Bool {
        selectedType != nil || selectedGeneration != nil
    }

    var generations: [Int] {
        Set(pokemon.map(\.generation)).sorted()
    }

    init(useCase: PokemonListUseCase, log: PokemonListLogLogic = PokemonListLogUseCase(), router: Router) {
        self.useCase = useCase
        self.log = log
        self.router = router
        let config = ScaffoldConfig.Builder()
            .setTitle("tab.pokedex".localized)
            .build()
        super.init(config: config)
    }

    override func didEmptyStateButtonClick() async {
        switch emptyStateAction {
        case .retry:
            hideEmptyState()
            await getPokemonIndex()
        case .clearFilters:
            clearFilters()
        case nil:
            break
        }
    }

    func logScreenView() {
        log.logScreenView()
    }

    /// Loads the index once; pull to refresh reloads it.
    func getPokemonIndex() async {
        guard pokemon.isEmpty else { return }
        do {
            pokemon = try await useCase.getPokemonIndex()
        } catch {
            handleGetPokemonIndexError(error)
        }
    }

    func refreshPokemonIndex() async {
        do {
            pokemon = try await useCase.refreshPokemonIndex()
            updateNoResultsState()
        } catch .cancelled {
            return
        } catch {
            showSnackbar(message: "pokemonList.refreshError".localized)
        }
    }

    func clearFilters() {
        selectedType = nil
        selectedGeneration = nil
    }

    func navigateToDetail(id: Int) {
        log.logPokemonSelected(id: id)
        router.navigate(to: .pokemonDetail(id: id))
    }

    // MARK: - Private

    /// A cancelled load (the screen went away) keeps the skeleton: the next appearance loads again.
    private func handleGetPokemonIndexError(_ error: APIError) {
        guard error != .cancelled else { return }
        let isNetworkError = error == .network
        let key = isNetworkError ? "pokemonList.error.network" : "pokemonList.error.generic"
        emptyStateAction = .retry
        showEmptyState(
            EmptyStateModel(
                title: "\(key).title".localized,
                message: "\(key).message".localized,
                systemImage: isNetworkError ? "wifi.slash" : "exclamationmark.triangle",
                buttonTitle: "common.retry".localized))
    }

    /// The search field and the filters stay on screen, so "no results" is an empty state with a way out.
    private func updateNoResultsState() {
        guard !pokemon.isEmpty else { return }
        guard cards.isEmpty else {
            emptyStateAction = nil
            hideEmptyState()
            return
        }
        emptyStateAction = hasActiveFilters ? .clearFilters : nil
        showEmptyState(
            EmptyStateModel(
                title: "pokemonList.noResults.title".localized,
                message: "pokemonList.noResults.message".localized,
                systemImage: "magnifyingglass",
                buttonTitle: hasActiveFilters ? "pokemonList.filter.clear".localized : nil))
    }
}
