//
//  HTTPURLResponse+Success.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        (200..<300).contains(statusCode)
    }
}
