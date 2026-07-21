//
//  NavigationViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 20/07/26.
//

import Foundation

extension GameViewModel {
    // MARK: - Navigation Flow
    
    public func startNewGame() {
        navigationPath = [.usernameInput]
        currentRoute = .usernameInput
    }
    
    public func continueGame() {
        guard let saveState = storageController.loadGame() else {
            navigationPath = []
            currentRoute = .landing
            return
        }
        self.gameState = saveState
        startGame(
            fromRound: saveState.currentRound,
            startNodeId: saveState.currentNodeId
        )
        navigationPath = [.timeline]
        currentRoute = .timeline
    }
    
    // Acceps and validates username input, and saves the game into disk
    // Then load Round 1 from JSON
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        var newState = GameState(username: trimmedName)
        newState.publishedPosts.append(UserPost.openingPost)
        storageController.saveGame(newState)
        self.gameState = newState
        
        loadStoryFromJSON(round: 1, startNodeId: "1A")
        
        navigationPath = [.prologue]
        currentRoute = .prologue
    }
    
    public func continueFromProlog() {
        navigationPath = [.timeline]
        currentRoute = .timeline
    }
    
    
    // Opens archive menu
    public func openArchive() {
        navigationPath = [.archive]
        currentRoute = .archive
    }
    
    
    // Return to main menu
    public func returnToLanding() {
        navigationPath.removeAll()
        currentRoute = .landing
    }
    
    // Overwrite active save
    public func deleteActiveSave() {
        storageController.deleteGame()
        self.gameState = nil
        self.currentNode = nil
        navigationPath.removeAll()
        currentRoute = .landing
    }
}
