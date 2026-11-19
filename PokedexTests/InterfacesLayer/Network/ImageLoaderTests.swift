//
//  ImageLoaderTests.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation
import Testing
import UIKit

struct ImageLoaderTests {

    // MARK: Test subject

    let sut: ImageLoader

    // MARK: Test vars

    let transport = HTTPTransportSpy()
    let diskCache = ResponseCache(directory: .temporaryDirectory.appending(path: UUID().uuidString))
    let url = URL(staticString: "https://example.com/25.png")
    let pngData = UIGraphicsImageRenderer(size: CGSize(width: 2, height: 2)).pngData { context in
        UIColor.systemYellow.setFill()
        context.fill(CGRect(x: .zero, y: .zero, width: 2, height: 2))
    }

    // MARK: Test setup

    init() {
        sut = ImageLoader(transport: transport, diskCache: diskCache)
    }

    var cacheKey: String {
        URLRequest(url: url).cacheKey
    }

    // MARK: Tests

    @Test func imageDownloadsAndStoresOnDisk() async {
        // Given
        transport.sendResponse = (pngData, 200)

        // When
        let image = await sut.image(for: url)

        // Then
        #expect(image != nil)
        #expect(await diskCache.entry(for: cacheKey)?.data == pngData)
    }

    @Test func imageReadsFromDiskWithoutNetwork() async {
        // Given
        await diskCache.store(pngData, for: cacheKey)

        // When
        let image = await sut.image(for: url)

        // Then
        #expect(image != nil)
        #expect(!transport.sendCalled)
    }

    @Test(arguments: [
        UnusableImageResponse(sendSuccess: false, statusCode: 200, isImage: true),
        UnusableImageResponse(sendSuccess: true, statusCode: 404, isImage: true),
        UnusableImageResponse(sendSuccess: true, statusCode: 200, isImage: false)
    ])
    func imageIsNilAndNotStoredForUnusableResponses(_ response: UnusableImageResponse) async {
        // Given
        transport.sendSuccess = response.sendSuccess
        transport.sendResponse = (response.isImage ? pngData : Data("not an image".utf8), response.statusCode)

        // When
        let image = await sut.image(for: url)

        // Then
        #expect(image == nil)
        #expect(await diskCache.entry(for: cacheKey) == nil)
    }
}

// MARK: - Helpers

nonisolated struct UnusableImageResponse: Sendable {
    let sendSuccess: Bool
    let statusCode: Int
    let isImage: Bool
}
