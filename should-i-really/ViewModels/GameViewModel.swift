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
        case ending
    }
    
    // MARK: - Core Properties
    public private(set) var currentRoute: GameRoute = .landing
    public private(set) var gameState: GameState?
        
    private(set) var currentNode: StoryNode?
    public private(set) var currentRound: Int = 1
    
    private var currentRoundDatabase: [String: StoryNode] = [:]
    
    public var availableStoryNodes: [StoryNode] {
        let sortedNodes = currentRoundDatabase.values.sorted { $0.id < $1.id }
        return Array(sortedNodes.reversed())
    }
    
    public var currentUsername: String? {
        gameState?.username
    }
    
    private let storageController: StorageController
    
    // MARK: - Initializer
    public init(storageController: StorageController = StorageController()) {
        self.storageController = storageController
                
        if storageController.hasSave {
            self.gameState = storageController.loadGame()
        }
    }
    
    // MARK: - Story Engine & JSON Loader
        
    public func startGame(fromRound round: Int, startNodeId: String) {
        currentRoute = .timeline
        loadStoryFromJSON(round: round, startNodeId: startNodeId)
    }
        
    private func loadStoryFromJSON(round: Int, startNodeId: String) {
        let fileName = "Round\(round)_Nodes"
            
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("ERROR: File \(fileName).json tidak ditemukan!")
            return
        }
            
        do {
            let data = try Data(contentsOf: url)
            let nodes = try JSONDecoder().decode([StoryNode].self, from: data)
                
            // Simpan ke memori dan change state saat ini
            self.currentRoundDatabase = Dictionary(
                uniqueKeysWithValues: nodes.map { ($0.id, $0)
                })
            self.currentNode = currentRoundDatabase[startNodeId]
            self.currentRound = round
                
            print("Berhasil memuat JSON Ronde \(round)")
        } catch {
            print("Gagal decode JSON Ronde \(round): \(error)")
        }
    }
        
    // MARK: - Execution Logic
        
    public func advanceStory(nextNodeId: String, chosenQuadrant: QuadrantPosition, chosenCaption: CaptionOption) {
        if let node = currentNode {
            let newPost = UserPost(nodeId: node.id, imageName: node.imageName, selectedQuadrant: chosenQuadrant, selectedCaptionText: chosenCaption.text, comments: chosenCaption.comments)
            
            if var state = self.gameState {
                state.publishedPosts.append(newPost)
                self.gameState = state
            }
        }
        
        if nextNodeId.hasPrefix("ENDING_") {
            self.currentRoute = .ending
            print("Game selesai, ending: \(nextNodeId)")
        } else {
            if let nextNode = currentRoundDatabase[nextNodeId] {
                self.currentNode = nextNode
                autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
            } else {
                self.currentRound += 1
                loadStoryFromJSON(
                    round: self.currentRound,
                    startNodeId: nextNodeId
                )
                autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
            }
        }
    }
    
    public var feedPosts: [UserPost] {
        return Array((gameState?.publishedPosts ?? []).reversed())
    }
    
    private func autoSaveProgress(round: Int, nodeId: String) {
        guard var state = self.gameState else { return }
        state.currentRound = round
        state.currentNodeId = nodeId
        
        self.gameState = state
        storageController.saveGame(state)
    }
    
    
    // MARK: - Navigation Control Flow
    
    public func startNewGame() {
        currentRoute = .usernameInput
    }
    
    public func continueGame() {
        guard let saveState = storageController.loadGame() else {
            currentRoute = .landing
            return
        }
        self.gameState = saveState
        startGame(
            fromRound: saveState.currentRound,
            startNodeId: saveState.currentNodeId
        )
    }
    
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !trimmedName.isEmpty else { return }
        
        let newState = GameState(username: trimmedName)
        storageController.saveGame(newState)
        self.gameState = newState
        startGame(fromRound: 1, startNodeId: "1A")
    }
    
    public func openArchive() {
        currentRoute = .archive
    }
    
    public func returnToLanding() {
        currentRoute = .landing
    }
    
    public func deleteActiveSave() {
        storageController.deleteGame()
        self.gameState = nil
        self.currentNode = nil
        currentRoundDatabase.removeAll()
        currentRoute = .landing
    }
}
