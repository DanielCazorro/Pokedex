//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI
import UIKit

/// Loads remote images with a memory cache and a disk cache. Artwork never changes, so cached images don't expire.
final class ImageLoader {
    static let shared = ImageLoader()

    private let transport: HTTPTransport
    private let diskCache: ResponseCache
    private let memoryCache = NSCache<NSURL, UIImage>()

    init(transport: HTTPTransport = URLSession.shared, diskCache: ResponseCache = .images) {
        self.transport = transport
        self.diskCache = diskCache
    }

    func image(for url: URL) async -> UIImage? {
        if let image = memoryCache.object(forKey: url as NSURL) {
            return image
        }
        let cacheKey = URLRequest(url: url).cacheKey
        let image: UIImage
        if let entry = await diskCache.entry(for: cacheKey), let cachedImage = await Self.decodeImage(entry.data) {
            image = cachedImage
        } else {
            guard let data = await download(url), let downloadedImage = await Self.decodeImage(data) else {
                return nil
            }
            await diskCache.store(data, for: cacheKey)
            image = downloadedImage
        }
        memoryCache.setObject(image, forKey: url as NSURL)
        return image
    }

    // MARK: - Private

    private func download(_ url: URL) async -> Data? {
        guard let (data, response) = try? await transport.send(URLRequest(url: url)),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.isSuccess
        else { return nil }
        return data
    }

    @concurrent
    nonisolated private static func decodeImage(_ data: Data) async -> UIImage? {
        await UIImage(data: data)?.byPreparingForDisplay()
    }
}

extension EnvironmentValues {
    @Entry var imageLoader = ImageLoader.shared
}
