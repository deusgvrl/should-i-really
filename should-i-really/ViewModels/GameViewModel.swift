//
//  GameViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation
import Observation
import SwiftUI

// MARK: - Game View Model Main Target
@MainActor
@Observable public final class GameViewModel {
    
    // MARK: - Game Routes
    
    /// Navigation routing destinations for homogeneous stack coordination.
    public enum GameRoute: Equatable, Hashable {
        case landing
        case usernameInput
        case prologue
        case timeline
        case feedView(postID: String)
        case archive
        case ending
    }
    
    // MARK: - Stored Properties
    
    /// The active route showing in the interface.
    public internal(set) var currentRoute: GameRoute = .landing
    
    /// The active player profile and simulation scores.
    public var gameState: GameState?
    
    /// The navigation array representing the stack hierarchy.
    public var navigationPath: [GameRoute] = []
    
    /// The current story node the player is active on.
    public internal(set) var currentNode: StoryNode?
    
    /// The active game round (representing tree depth).
    public internal(set) var currentRound: Int = 1
    
    /// The active round's database mapping story node IDs to story nodes.
    public var currentRoundDatabase: [String: StoryNode] = [:]
    
    /// Controller managing persistence operations to UserDefaults.
    public let storageController: StorageController
    
    /// Tracks the ID of the graduation ending reached (if any).
    /// Writable within the project target extensions, readable by views.
    public internal(set) var lastEndingId: String?
    
    // MARK: - Init
    
    /// Initializes the GameViewModel, loading any active save state from storage.
    ///
    /// - Parameter storageController: Storage manager reference.
    public init(storageController: StorageController) {
        self.storageController = storageController
        
        if storageController.hasSave {
            self.gameState = storageController.loadGame()
        }
    }
    
    public convenience init() {
        self.init(storageController: StorageController())
    }
}
