//
//  AppTestMode.swift
//  Pokedex
//
//  Created by Daniel Cazorro on 19/11/2026.
//

import Foundation

func appIsRunningOnTestMode() -> Bool {
    #if DEBUG
    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    #else
    false
    #endif
}
