//
//  Fixture.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation
import Testing

/// Real API responses saved in `PokedexTests/Fixtures/`.
enum Fixture {
    static func data(named name: String) throws -> Data {
        let url = try #require(Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: url)
    }
}

private final class BundleToken {}
