//
//  RouterStack.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// `NavigationStack` that owns a tab's `Router` and maps every `Route` to its screen. All navigation goes through
/// here.
struct RouterStack<Root: View>: View {
    @State private var router = Router()
    private let root: (Router) -> Root

    init(@ViewBuilder root: @escaping (Router) -> Root) {
        self.root = root
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            root(router)
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .pokemonDetail:
            PlaceholderView.getView(title: "tab.pokedex".localized)
        }
    }
}
