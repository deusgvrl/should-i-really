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
    
    // MARK: - Core Properties
    public private(set) var currentRoute: GameRoute = .landing
    public private(set) var gameState: GameState?
    
    private(set) var currentNode: StoryNode
    
    private let storageController: StorageController
    
    // MARK: - Storyline Database Graph
    private let storylineDatabase: [String: StoryNode] = [
        "Scene_1": StoryNode(
            id: "Scene_1",
            imageName: "SampleImage1",
            activeQuadrants: [.topLeft, .bottomRight],
            
            quadrantCaptions: [
                .topLeft: [
                    "Caption 1",
                    "Caption 2"
                ],
                .bottomRight: [
                    "Caption 1",
                    "Caption 2"
                ]
            ],
            
            nextNodePaths: [
                PlayerChoice(quadrant: .topLeft, captionIndex: 0): "Scene_2",
                PlayerChoice(quadrant: .topLeft, captionIndex: 1): "Scene_3",
                PlayerChoice(quadrant: .bottomRight, captionIndex: 0): "Scene_2",
                PlayerChoice(quadrant: .bottomRight, captionIndex: 1): "Scene_3"
            ]
        ),
        "Scene_2": StoryNode(
            id: "Scene_2",
            imageName: "SampleImage2",
            activeQuadrants: [.topLeft, .topRight],
            
            quadrantCaptions: [
                .topLeft: [
                    "Caption 1",
                    "Caption 2"
                ],
                .topRight: [
                    "Caption 1",
                    "Caption 2"
                ]
            ],
            
            nextNodePaths: [
                PlayerChoice(quadrant: .topLeft, captionIndex: 0): "Scene_1",
                PlayerChoice(quadrant: .topLeft, captionIndex: 1): "Scene_3",
                PlayerChoice(quadrant: .topRight, captionIndex: 0): "Scene_1",
                PlayerChoice(quadrant: .topRight, captionIndex: 1): "Scene_3"
            ]
        ),
        "Scene_3": StoryNode(
            id: "Scene_3",
            imageName: "SampleImage3",
            activeQuadrants: [.topRight, .bottomRight],
            
            quadrantCaptions: [
                .topRight: [
                    "Caption 1",
                    "Caption 2"
                ],
                .bottomRight: [
                    "Caption 1",
                    "Caption 2"
                ]
            ],
            
            nextNodePaths: [
                PlayerChoice(quadrant: .topRight, captionIndex: 0): "Scene_2",
                PlayerChoice(quadrant: .topRight, captionIndex: 1): "Scene_1",
                PlayerChoice(quadrant: .bottomRight, captionIndex: 0): "Scene_2",
                PlayerChoice(quadrant: .bottomRight, captionIndex: 1): "Scene_1"
            ]
        )
    ]
    
    // MARK: - Initializer
    public init(storageController: StorageController = StorageController()) {
        self.storageController = storageController
        
        self.currentNode = storylineDatabase["Scene_1"]!
        
        if storageController.hasSave {
            self.gameState = storageController.loadGame()
        }
    }
    
    // MARK: - Story Engine Execution Logic
    
    public func advanceStory(chosenQuadrant: Quadrant, chosenCaptionIndex: Int) {
        let choice = PlayerChoice(quadrant: chosenQuadrant, captionIndex: chosenCaptionIndex)
        
        if let nextNodeID = currentNode.nextNodePaths[choice],
           let nextNode = storylineDatabase[nextNodeID] {
            self.currentNode = nextNode
        }
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
        currentRoute = .timeline
    }
    
    public func enterUsername(_ username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newState = GameState(username: trimmedName)
        storageController.saveGame(newState)
        self.gameState = newState
        currentRoute = .timeline
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
        self.currentNode = storylineDatabase["Scene_1"]!
        currentRoute = .landing
    }
}
