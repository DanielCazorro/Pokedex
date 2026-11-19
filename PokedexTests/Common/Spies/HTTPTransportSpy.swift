//
//  HTTPTransportSpy.swift
//  PokedexTests
//
//  Created by Daniel Cazorro on 19/11/2026.
//

@testable import Pokedex

import Foundation

final class HTTPTransportSpy: HTTPTransport {
    var sendCalled = false
    var sendSuccess = true
    var sendResponse = (data: Data("{}".utf8), statusCode: 200)
    var sendError: any Error = URLError(.notConnectedToInternet)

    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        sendCalled = true
        guard sendSuccess else { throw sendError }
        guard let url = request.url,
              let response = HTTPURLResponse(
                url: url, statusCode: sendResponse.statusCode, httpVersion: nil, headerFields: nil)
        else { throw URLError(.badURL) }
        return (sendResponse.data, response)
    }
}
