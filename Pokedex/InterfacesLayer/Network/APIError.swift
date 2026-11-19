//
//  APIError.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

nonisolated enum APIError: Error, Equatable {
    case network
    case server(statusCode: Int)
    case invalidRequest
    case invalidResponse
    case cancelled
}
