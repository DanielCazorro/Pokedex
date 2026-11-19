//
//  RemoteImage.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Image loaded through the `ImageLoader` in the environment. Shows a placeholder until (and unless) it loads.
struct RemoteImage: View {
    let url: URL

    @Environment(\.imageLoader) private var imageLoader
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .accessibilityHidden(true)
        .task(id: url) {
            image = await imageLoader.image(for: url)
        }
    }
}

// MARK: - Preview

#Preview {
    RemoteImage(url: Config.artworkURL(for: 25))
        .frame(width: 200, height: 200)
}
