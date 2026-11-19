//
//  LoadingView.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Full-screen loading overlay that blocks touches on the content behind it.
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .controlSize(.large)
            .padding(Spacing.l)
            .glassEffect(in: .rect(cornerRadius: CornerRadius.card))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.1))
    }
}

// MARK: - Preview

#Preview {
    LoadingView()
}
