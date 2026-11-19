//
//  HTTPTransport.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

/// The only piece that talks to the network. Tests replace it with a spy.
protocol HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPTransport {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
