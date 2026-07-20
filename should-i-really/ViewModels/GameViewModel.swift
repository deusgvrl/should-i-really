//
//  GameViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
public final class GameViewModel {
    // MARK: - Route States
    public enum GameRoute: Equatable, Hashable {
        case landing
        case usernameInput
        case prologue
        case timeline
        case feedView (postID: String)
        case archive
        case ending
    }
    
    // MARK: - Core Properties
    public private(set) var currentRoute: GameRoute = .landing
    public private(set) var gameState: GameState?
    public private(set) var lastEndingId: String?
    
    var navigationPath: [GameRoute] = []
    
    public private(set) var currentNode: StoryNode?
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
    
    public func injectEndingPost() {
        gameState?.publishedPosts.append(UserPost.endingPost)
    }
    
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
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            let nodes = try decoder.decode([StoryNode].self, from: data)
                
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
            let cropResult: CropType = (chosenQuadrant == node.crops.positiveCrop.quadrant) ? .positive : .negative
            
            let captionResult: CropType = chosenCaption.type
            
            let newPost = UserPost(nodeId: node.id, imageName: node.bigPictureId, selectedQuadrant: chosenQuadrant, selectedCaptionText: chosenCaption.text, comment: chosenCaption.comments, photoGuardResult: cropResult, vibeCheckResult: captionResult)
            
            if var state = self.gameState {
                state.publishedPosts.append(newPost)
                self.gameState = state
            }
        }
        
        if nextNodeId.hasPrefix("ENDING_") {
            self.lastEndingId = nextNodeId
            print("Game selesai, ending: \(nextNodeId)")
        } else {
            if let nextNode = currentRoundDatabase[nextNodeId] {
                self.currentNode = nextNode
                autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
            } else {
                self.currentRound += 1
                DispatchQueue.main.asyncAfter(deadline:.now() + 0.6) {
                    self.loadStoryFromJSON(
                        round: self.currentRound,
                        startNodeId: nextNodeId
                    )
                    self.autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
                }
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
    
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
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
        print("current nav path = \(navigationPath)")
        navigationPath = [.timeline]
        currentRoute = .timeline
        print("nav path after continue from prolog = \(navigationPath)")
    }
    
    public func openArchive() {
        navigationPath = [.archive]
        currentRoute = .archive
    }
    
    public func returnToLanding() {
        navigationPath.removeAll()
        currentRoute = .landing
    }
    
    public func deleteActiveSave() {
        storageController.deleteGame()
        self.gameState = nil
        self.currentNode = nil
        currentRoundDatabase.removeAll()
        navigationPath.removeAll()
        currentRoute = .landing
    }
    
    public func markCommentAsRevealed(for postID: String) {
        guard var state = self.gameState else { return }
        
        if let index = state.publishedPosts.firstIndex(where: { $0.id == postID }) {
            state.publishedPosts[index].isCommentRevealed = true
            self.gameState = state
            storageController.saveGame(state)
        }
    }
}
