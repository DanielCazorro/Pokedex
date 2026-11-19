//
//  RootView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        ContentUnavailableView("app.name", systemImage: "book.closed")
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
