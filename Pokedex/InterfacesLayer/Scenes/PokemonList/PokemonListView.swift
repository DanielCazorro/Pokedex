//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct PokemonListView: View {
    @State private var viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScaffoldView(viewModel: viewModel) {
            ScrollView {
                if viewModel.isShowingSkeleton {
                    PokemonCardSkeletonGrid()
                } else {
                    PokemonCardGrid(cards: viewModel.cards, onSelect: viewModel.navigateToDetail)
                }
            }
            .refreshable {
                await viewModel.refreshPokemonIndex()
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "pokemonList.search.prompt".localized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filterMenu
            }
        }
        .onAppear {
            viewModel.logScreenView()
        }
        .task {
            await viewModel.getPokemonIndex()
        }
    }

    private var filterMenu: some View {
        Menu {
            Picker("pokemonList.filter.type".localized, selection: $viewModel.selectedType) {
                Text("pokemonList.filter.allTypes".localized).tag(PokemonType?.none)
                ForEach(PokemonType.allCases, id: \.self) { type in
                    Text(type.localizedName).tag(Optional(type))
                }
            }
            .pickerStyle(.menu)
            Picker("pokemonList.filter.generation".localized, selection: $viewModel.selectedGeneration) {
                Text("pokemonList.filter.allGenerations".localized).tag(Int?.none)
                ForEach(viewModel.generations, id: \.self) { generation in
                    Text(String(format: "generation.name".localized, generation.romanNumeral)).tag(Optional(generation))
                }
            }
            .pickerStyle(.menu)
            if viewModel.hasActiveFilters {
                Button("pokemonList.filter.clear".localized, systemImage: "xmark", role: .destructive) {
                    viewModel.clearFilters()
                }
            }
        } label: {
            Label(
                "pokemonList.filter.title".localized,
                systemImage: viewModel.hasActiveFilters
                    ? "line.3.horizontal.decrease.circle.fill"
                    : "line.3.horizontal.decrease.circle")
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    RouterStack { router in
        PokemonListView.getView(repository: PokemonIndexAPIRepositorySpy(), router: router)
    }
}
#endif

extension PokemonListView {
    static func getView(
        repository: PokemonIndexRepository = PokemonIndexAPIRepository(),
        router: Router
    ) -> PokemonListView {
        let useCase = PokemonListUseCase(repository: resolveRepository(repository))
        let viewModel = PokemonListViewModel(useCase: useCase, router: router)
        return PokemonListView(viewModel: viewModel)
    }
}

private func resolveRepository(_ repository: PokemonIndexRepository) -> PokemonIndexRepository {
    #if DEBUG
    appIsRunningOnTestMode() ? PokemonIndexAPIRepositorySpy() : repository
    #else
    repository
    #endif
}
