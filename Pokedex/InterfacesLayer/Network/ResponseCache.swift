//
//  ResponseCache.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

nonisolated struct CacheEntry: Sendable {
    let data: Data
    let date: Date

    var age: TimeInterval {
        Date.now.timeIntervalSince(date)
    }
}

/// Disk cache for API responses. Best effort: a failed read is a miss and a failed write is ignored.
actor ResponseCache {
    static let shared = ResponseCache(directory: .cachesDirectory.appending(path: "APIResponses"))

    private let directory: URL

    init(directory: URL) {
        self.directory = directory
    }

    func entry(for key: String) -> CacheEntry? {
        let fileURL = directory.appending(path: key)
        guard let data = try? Data(contentsOf: fileURL),
              let date = try? fileURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
        else { return nil }
        return CacheEntry(data: data, date: date)
    }

    func store(_ data: Data, for key: String) {
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try? data.write(to: directory.appending(path: key), options: .atomic)
    }
}
