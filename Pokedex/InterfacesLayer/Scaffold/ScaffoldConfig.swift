//
//  ScaffoldConfig.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

struct ScaffoldConfig {
    private(set) var title = String.empty

    final class Builder {
        private var config = ScaffoldConfig()

        func setTitle(_ title: String) -> Builder {
            config.title = title
            return self
        }

        func build() -> ScaffoldConfig {
            config
        }
    }
}
