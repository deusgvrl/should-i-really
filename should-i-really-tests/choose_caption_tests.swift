//
//  choose_caption_tests.swift
//  should-i-really
//
//  Created by Steffany Florence on 21/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct ChooseCaptionTests {
    
    let gameViewModel: GameViewModel
    let postCreationViewModel: PostCreationViewModel
    
    init() {
        gameViewModel = GameViewModel()
        gameViewModel.enterUsername("TestPlayer")
        postCreationViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    }
    
    @Test("User selects a caption from the available choices")
    func test_ChooseCaption() throws {
        defer { gameViewModel.deleteActiveSave() }
        
        let currentNode = try #require(gameViewModel.currentNode)
        
        let validQuadrant = currentNode.crops.positiveCrop.quadrant
        postCreationViewModel.selectedQuadrant = validQuadrant
        postCreationViewModel.confirmPhotoSelection()
        
        let availableCaptions = postCreationViewModel.availableCaptions
        let chosenCaption: CaptionOption = try #require(availableCaptions.first)
        
        postCreationViewModel.selectCaption(chosenCaption)
        
        #expect(postCreationViewModel.selectedCaption?.id == chosenCaption.id)
    }
}
