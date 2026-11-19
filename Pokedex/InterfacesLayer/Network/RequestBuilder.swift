//
//  RequestBuilder.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

struct RequestBuilder {
    private var url: URL
    private var method = HTTPMethod.get
    private var body: (any Encodable & Sendable)?
    private var cacheMaxAge: TimeInterval?

    init(baseURL: URL) {
        url = baseURL
    }

    func set(path: String) -> RequestBuilder {
        var builder = self
        builder.url = url.appending(path: path)
        return builder
    }

    func set(method: HTTPMethod) -> RequestBuilder {
        var builder = self
        builder.method = method
        return builder
    }

    func set(body: some Encodable & Sendable) -> RequestBuilder {
        var builder = self
        builder.body = body
        return builder
    }

    func set(cacheMaxAge: TimeInterval) -> RequestBuilder {
        var builder = self
        builder.cacheMaxAge = cacheMaxAge
        return builder
    }

    func build() -> APIRequest {
        APIRequest(url: url, method: method, body: body, cacheMaxAge: cacheMaxAge)
    }
}
