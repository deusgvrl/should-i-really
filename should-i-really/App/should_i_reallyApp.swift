//
//  should_i_reallyApp.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI
import SwiftData

@main
struct should_i_reallyApp: App {
    @State private var gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environment(gameViewModel)
                .modelContainer(for: UnlockedEndings.self)
        }
    }
}
