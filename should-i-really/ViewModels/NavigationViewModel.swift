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
    
    public func isValidUsername(_ username: String) -> Bool {
        // Min 1, Max 16 karakter
        guard username.count >= 1 && username.count <= 16 else { return false }
        
        // tidak boleh 0
        guard username != "0" else { return false }
        
        // cuma huruf, angka, underscore (_), dan titik (.)
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_."))
        guard username.unicodeScalars.allSatisfy({ allowedCharacterSet.contains($0) }) else { return false }
        
        // karakter spesial (_ dan .) tidak boleh bersebalahan
        let invalidConsecutivePatterns = ["..", "__", "._", "_."]
        for pattern in invalidConsecutivePatterns {
            if username.contains(pattern) { return false }
        }
        
        return true
    }
    
    // Acceps and validates username input, and saves the game into disk
    // Then load Round 1 from JSON
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidUsername(trimmedName) else { return }
        
        let shuffledOrnaments = ["icon_star", "icon_pin", "icon_pushPin"].shuffled()
        
        var newState = GameState(username: trimmedName, ornamentsOrder: shuffledOrnaments)
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
