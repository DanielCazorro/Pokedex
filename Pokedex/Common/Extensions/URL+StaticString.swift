//
//  URL+StaticString.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

extension URL {
    /// For URL literals written in the code: an invalid one is a programming error, so it stops the app right away.
    init(staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            preconditionFailure("Invalid URL literal: \(staticString)")
        }
        self = url
    }
}
