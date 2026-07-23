//
//  EngineViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 20/07/26.
//

import Foundation

extension GameViewModel {
    // MARK: - Computed Properties
    
    public var currentUsername: String? {
        gameState?.username
    }
    
    public var availableStoryNodes: [StoryNode] {
        let sortedNodes = currentRoundDatabase.values.sorted { $0.id < $1.id }
        return Array(sortedNodes.reversed())
    }
    
    // MARK: - Story Control Engine
    
    public func injectEndingPost() {
        guard var state = gameState else { return }
        state.publishedPosts.append(UserPost.endingPost)
        self.gameState = state
        storageController.saveGame(state)
    }
    
    public func startGame(fromRound round: Int, startNodeId: String) {
        currentRoute = .timeline
        loadStoryFromJSON(round: round, startNodeId: startNodeId)
    }
    
    
    // Decodes JSON data file
    // round = Target Round Integer, startNodeId = Starting Node Index
    public func loadStoryFromJSON(round: Int, startNodeId: String) {
        let fileName = "Round\(round)_Nodes"
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("ERROR: File \(fileName).json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true
            let nodes = try decoder.decode([StoryNode].self, from: data)
            
            self.currentRoundDatabase = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0)})
            self.currentNode = currentRoundDatabase[startNodeId]
            self.currentRound = round
            
            print("Successfully loaded JSON Round \(round)")
        } catch {
            print("Failed to decode JSON Round \(round)")
        }
    }
    
    
    // Advances through the branch story based on selected values, and updates game state scores, also autosaves
    // nextNodeId = Next branching target, chosenQuadrant/chosenCaption = chosen photo/caption
    public func advanceStory(nextNodeId: String, chosenQuadrant: QuadrantPosition, chosenCaption: CaptionOption) {
        if let node = currentNode {
            let cropResult: CropType = (chosenQuadrant == node.crops.positiveCrop.quadrant) ? .positive : .negative
            let captionResult: CropType = chosenCaption.type
            
            let newPost = UserPost(nodeId: node.id, imageName: node.bigPictureId, selectedQuadrant: chosenQuadrant, selectedCaptionText: chosenCaption.text, comment: chosenCaption.comments, photoGuardResult: cropResult, vibeCheckResult: captionResult, timeline: node.timeline)
            
            if var state = self.gameState {
                state.publishedPosts.append(newPost)
                self.gameState = state
            }
        }
        
        if nextNodeId.hasPrefix("ENDING_") {
            self.lastEndingId = nextNodeId
            self.gameState?.lastEndingId = nextNodeId
            if let state = self.gameState {
                storageController.saveGame(state)
            }
            self.currentRoute = .ending
            print("Scenario complete, ending is: ending \(nextNodeId)")
        } else {
            if let nextNode = currentRoundDatabase[nextNodeId] {
                self.currentNode = nextNode
                autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
            } else {
                self.currentRound += 1
                
                // Delay load to allow clean transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.loadStoryFromJSON(round: self.currentRound, startNodeId: nextNodeId)
                    self.autoSaveProgress(round: self.currentRound, nodeId: nextNodeId)
                }
            }
        }
    }
    
    
    // Sends active profile state to UserDefaults
    // Uses params: round = Game Round Node, and nodeId = story node coords
    public func autoSaveProgress(round: Int, nodeId: String) {
        guard var state = self.gameState else { return }
        state.currentRound = round
        state.currentNodeId = nodeId
        
        
        self.gameState = state
        storageController.saveGame(state)
        
    }
}
