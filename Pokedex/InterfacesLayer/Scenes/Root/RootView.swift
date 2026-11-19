//
//  RootView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("tab.pokedex", systemImage: "square.grid.2x2.fill") {
                RouterStack { router in
                    PokemonListView.getView(router: router)
                }
            }
            Tab("tab.favorites", systemImage: "heart.fill") {
                RouterStack { _ in
                    PlaceholderView.getView(title: "tab.favorites".localized)
                }
            }
            Tab("tab.comparator", systemImage: "arrow.left.arrow.right") {
                RouterStack { _ in
                    PlaceholderView.getView(title: "tab.comparator".localized)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
