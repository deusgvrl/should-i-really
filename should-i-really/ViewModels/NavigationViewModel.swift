//
//  NavigationViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 20/07/26.
//

import Foundation

// MARK: - Validation Error Types
public enum UsernameValidationError {
    case exceedsLength
    case containsSpecialSymbols
    case containsRepeatableSymbols
}

extension GameViewModel {
    // MARK: - Navigation Flow
    
    public func startNewGame() {
        self.lastEndingId = nil
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
        self.lastEndingId = saveState.lastEndingId
        startGame(
            fromRound: saveState.currentRound,
            startNodeId: saveState.currentNodeId
        )
        navigationPath = [.timeline]
        currentRoute = .timeline
    }
    
    public func validateUsername(_ username: String) -> [UsernameValidationError] {
        var errors: [UsernameValidationError] = []
        
        if username.count > 16 {
            errors.append(.exceedsLength)
        }
        
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_."))
        let hasInvalidChars = !username.unicodeScalars.allSatisfy({ allowedCharacterSet.contains($0) })
        if hasInvalidChars || username == "0" {
            errors.append(.containsSpecialSymbols)
        }
        
        let invalidConsecutivePatterns = ["..", "__", "._", "_."]
        if invalidConsecutivePatterns.contains(where: { username.contains($0) }) {
            errors.append(.containsRepeatableSymbols)
        }
        
        return errors
    }
    
    public func isValidUsername(_ username: String) -> Bool {
        guard !username.isEmpty else { return false }
        return validateUsername(username).isEmpty
    }
    
    public func usernameErrorMessage(for username: String) -> String? {
        let errors = validateUsername(username)
        guard !errors.isEmpty else { return nil }
        
        var clauses: [String] = []
        for error in errors {
            switch error {
            case .exceedsLength:
                clauses.append("exceed 16 characters")
            case .containsSpecialSymbols:
                clauses.append("contain special symbols")
            case .containsRepeatableSymbols:
                clauses.append("contain repeatable symbols")
            }
        }
        let formattedText: String
        if clauses.count == 1 {
            formattedText = clauses[0]
        } else if clauses.count == 2 {
            formattedText = "\(clauses[0]) or \(clauses[1])"
        } else {
            let initial = clauses.dropLast().joined(separator: ", ")
            formattedText = "\(initial), or \(clauses.last!)"
        }
        
        return "Your username should not \(formattedText)."
    }
    
    // Acceps and validates username input, and saves the game into disk
    // Then load Round 1 from JSON
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidUsername(trimmedName) else { return }
        
        self.lastEndingId = nil
        
        let shuffledOrnaments = ["icon_star", "icon_pin", "icon_pushPin"].shuffled()
        
        var newState = GameState(username: trimmedName, ornamentsOrder: shuffledOrnaments, lastEndingId: nil, currentTimeline: TimelineData(year: 1, semester: 1, month: 1))
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
    
    // Opens tutorial menu
    public func openTutorial() {
        navigationPath = [.tutorial]
        currentRoute = .tutorial
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
        self.lastEndingId = nil
        navigationPath.removeAll()
        currentRoute = .landing
    }
}
