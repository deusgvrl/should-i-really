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
