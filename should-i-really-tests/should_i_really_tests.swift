//
//  should_i_really_tests.swift
//  should-i-really-tests
//
//  Created by Steffany Florence on 17/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct CompletePostFlowTests {
    
    let gameViewModel: GameViewModel
    let postCreationViewModel: PostCreationViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
        postCreationViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    }
    
    @Test("User can select quadrant 1, pick a caption, and post with a single comment")
    func completePostCreationAndCommentFlow() throws {
        defer { gameViewModel.deleteActiveSave() }

        let initialFeedCount = gameViewModel.feedPosts.count
        let currentNode = try #require(gameViewModel.currentNode, "JSON must be loaded!")
        #expect(currentNode.id == "1A")
        
        let selectedQuadrant = try #require(QuadrantPosition(rawValue: 1))
        postCreationViewModel.selectedQuadrant = selectedQuadrant
        postCreationViewModel.confirmPhotoSelection()
        
        let availableCaptions = postCreationViewModel.availableCaptions
        let chosenCaption = try #require(availableCaptions.first)
        
        postCreationViewModel.selectCaption(chosenCaption)
        postCreationViewModel.finalizeAndPost()
        
        let updatedFeed = gameViewModel.feedPosts
        #expect(updatedFeed.count == initialFeedCount + 1)
        
        let newlyPublishedPost = try #require(updatedFeed.first)
        let publishedComment = try #require(newlyPublishedPost.comment, "Published post has no comment")
        let captionComment = try #require(chosenCaption.comments, "Chosen caption has no comment")
        
        #expect(publishedComment.id == captionComment.id)
        #expect(!publishedComment.text.isEmpty)
        
        #expect(gameViewModel.currentNode?.id == chosenCaption.nextNodeId)
    }
}

@MainActor
struct StoryGameViewModelTests {
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
