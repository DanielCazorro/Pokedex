//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import SwiftUI

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            if appIsRunningOnTestMode() {
                Color.clear
            } else {
                RootView()
            }
        }
    }
}
