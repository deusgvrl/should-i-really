//
//  posted_comment_tests.swift
//  should-i-really
//
//  Created by Steffany Florence on 21/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct PublishPostTests {
    
    let gameViewModel: GameViewModel
    let postCreationViewModel: PostCreationViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
        postCreationViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    }
    
    @Test("User publishes post, verifying feed update, correct image/caption, and comment delivery")
    func test_PublishPostAndVerifyFeed() async throws {
        defer { gameViewModel.deleteActiveSave() }
        
        let initialFeedCount = gameViewModel.feedPosts.count
        let currentNode = try #require(gameViewModel.currentNode)
        
        let validQuadrant = currentNode.crops.positiveCrop.quadrant
        postCreationViewModel.selectedQuadrant = validQuadrant
        postCreationViewModel.confirmPhotoSelection()
        
        let chosenCaption: CaptionOption = try #require(postCreationViewModel.availableCaptions.first)
        postCreationViewModel.selectCaption(chosenCaption)
        
        postCreationViewModel.finalizeAndPost()
        
        let updatedFeed = gameViewModel.feedPosts
        #expect(updatedFeed.count == initialFeedCount + 1)
        
        let newlyPublishedPost = try #require(updatedFeed.first)
        
        #expect(newlyPublishedPost.selectedQuadrant == validQuadrant)
        #expect(newlyPublishedPost.selectedCaptionText == chosenCaption.text)
    }
}
