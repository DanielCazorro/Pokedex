//
//  Router.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Observation

enum Route: Hashable {
    case pokemonDetail(id: Int)
}

/// Navigation state of one tab. ViewModels receive it to push screens.
@Observable
final class Router {
    var path: [Route] = []

    func navigate(to route: Route) {
        path.append(route)
    }
}
