//
//  RemoteImage.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

/// Image loaded through the `ImageLoader` in the environment. Shows a placeholder until (and unless) it loads.
/// Inside a redacted (skeleton) view it doesn't load anything.
struct RemoteImage: View {
    let url: URL

    @Environment(\.imageLoader) private var imageLoader
    @Environment(\.redactionReasons) private var redactionReasons
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
            // Only skeletons: the system can add other reasons (`.privacy`) to normal content.
            guard !redactionReasons.contains(.placeholder) else { return }
            image = await imageLoader.image(for: url)
        }
    }
}

// MARK: - Preview

#Preview {
    RemoteImage(url: Config.artworkURL(for: 25))
        .frame(width: 200, height: 200)
}
