//
//  story_tests.swift
//  should-i-really-tests
//
//  Created by Jose Putra Perdana Taneo on 21/07/26.
//

import Testing
@testable import should_i_really


@MainActor
struct Story_tests {
    let gameViewModel: GameViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
    }
    
    @Test("User can move to ending route when they reach the end of the story")
    func testAdvanceStoryRoutesToEnding() throws {
        defer { gameViewModel.deleteActiveSave() }
        let captionOption: CaptionOption = CaptionOption(id: "1", type: .positive, text: "Caption", nextNodeId: "ENDING_A", comments: nil)
        
        gameViewModel.advanceStory(nextNodeId: "ENDING_A", chosenQuadrant: .bottomLeft, chosenCaption: captionOption)
        
        #expect(gameViewModel.currentRoute == .ending)
    }
    
    @Test("User can view their post insights based on the cropped picture and caption they choose")
    func testPostInsights() throws {
        defer { gameViewModel.deleteActiveSave() }
        
        let node = try #require(gameViewModel.currentNode)
        let positiveQuadrant = node.crops.positiveCrop.quadrant
        let captionOption: CaptionOption = CaptionOption(id: "1A", type: .positive, text: "Caption", nextNodeId: "2B", comments: nil)
        
        gameViewModel.advanceStory(nextNodeId: node.id, chosenQuadrant: positiveQuadrant, chosenCaption: captionOption)
        
        let newestPost = try #require(gameViewModel.feedPosts.first)
        
        #expect(newestPost.photoGuardResult == .positive)
        #expect(newestPost.vibeCheckResult == .positive)
        
    }
}
