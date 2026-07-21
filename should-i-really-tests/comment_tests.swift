//
//  comment_test.swift
//  should-i-really
//
//  Created by Steffany Florence on 21/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct CommentNotificationTests {
    
    let gameViewModel: GameViewModel
    let postCreationViewModel: PostCreationViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
        postCreationViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    }
    
    @Test("Verifies published post receives correct comment and notification trigger")
    func test_CommentAndNotification() throws {
        defer { gameViewModel.deleteActiveSave() }
        
        let currentNode = try #require(gameViewModel.currentNode)
        let validQuadrant = currentNode.crops.positiveCrop.quadrant
        
        postCreationViewModel.selectedQuadrant = validQuadrant
        postCreationViewModel.confirmPhotoSelection()
        
        let chosenCaption: CaptionOption = try #require(postCreationViewModel.availableCaptions.first)
        postCreationViewModel.selectCaption(chosenCaption)
        
        postCreationViewModel.finalizeAndPost()
        
        let newlyPublishedPost = try #require(gameViewModel.feedPosts.first)
        
        if let expectedComment = chosenCaption.comments {
            let publishedComment = try #require(
                newlyPublishedPost.comment,
                "Published post should have an attached comment"
            )
            #expect(publishedComment.id == expectedComment.id)
            #expect(
                newlyPublishedPost.isCommentRevealed == false,
                "Comment must start hidden so notification can display on appear"
            )
        }
    }
}
