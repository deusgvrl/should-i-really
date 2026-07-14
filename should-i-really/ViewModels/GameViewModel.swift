//
//  GameViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation
import Observation

@Observable
public final class GameViewModel {
    
    // MARK: - Route States
    public enum GameRoute: Equatable {
        case landing
        case usernameInput
        case timeline
        case archive
    }
    
    // MARK: - Published Properties
    public private(set) var currentRoute: GameRoute = .landing
    public private(set) var gameState: GameState?
    
    private let storageController: StorageController
    
    // MARK: - Initializer
    public init (storageController: StorageController = StorageController()) {
        self.storageController = storageController
        
        if storageController.hasSave {
            self.gameState = storageController.loadGame()
        }
    }
    
    // MARK: - Navigation
    
    /// Starts a new game
    public func startNewGame() {
        currentRoute = .usernameInput
    }
    
    /// Resumes the game
    public func continueGame() {
        guard let saveState = storageController.loadGame() else {
            currentRoute = .landing
            return
        }
        self.gameState = saveState
        currentRoute = .timeline
    }
    
    /// Navigates to the username input page and persists
    /// Username parameter : User typed input handling
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newState = GameState(username: trimmedName)
        storageController.saveGame(newState)
        self.gameState = newState
        currentRoute = .timeline
    }
    
    /// Navigates to archive menu
    public func openArchive() {
        currentRoute = .archive
    }
    
    /// Returns back to main menu
    public func returnToLanding() {
        currentRoute = .landing
    }
    
    /// Deletes the current active save state and resets the coordinate path to landing
    public func deleteActiveSave() {
        storageController.deleteGame()
        self.gameState = nil
        currentRoute = .landing
    }
}
