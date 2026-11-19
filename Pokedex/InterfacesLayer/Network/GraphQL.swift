//
//  GraphQL.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

nonisolated struct GraphQLRequest: Encodable, Sendable {
    let query: String
}

/// `data` is not optional: a response with only `errors` fails to decode, so it's never cached.
nonisolated struct GraphQLResponse<ResponseData: Decodable & Sendable>: Decodable, Sendable {
    let data: ResponseData
}
