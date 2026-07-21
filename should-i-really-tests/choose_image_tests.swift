//
//  should_i_really_tests.swift
//  should-i-really-tests
//
//  Created by Steffany Florence on 17/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct ChooseImageQuadrantTests {
    
    let gameViewModel: GameViewModel
    let postCreationViewModel: PostCreationViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
        postCreationViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    }
    
    @Test("User navigates to post creation and selects an image quadrant")
    func test_ChooseImageQuadrant() throws {
        defer { gameViewModel.deleteActiveSave() }
        
        let currentNode = try #require(gameViewModel.currentNode, "JSON must be loaded")
        
        let validQuadrant = currentNode.crops.positiveCrop.quadrant
        postCreationViewModel.selectedQuadrant = validQuadrant
        
        postCreationViewModel.confirmPhotoSelection()
        
        #expect(postCreationViewModel.navigateToCaptionScreen == true)
        #expect(!postCreationViewModel.availableCaptions.isEmpty)
    }
}
