//
//  onboarding_tests.swift
//  should-i-really
//
//  Created by Michael David Sin on 21/07/26.
//

import Testing
@testable import should_i_really

@MainActor
struct OnboardingTests {
    let gameViewModel: GameViewModel
    
    init() {
        gameViewModel = GameViewModel()
    }
    
    // MARK: - Test 1: Initial Game State
    @Test("Initial state should be at landing route with empty game state")
    func testInitialStateIsLanding() {
        
        gameViewModel.deleteActiveSave()
        
        #expect(gameViewModel.currentRoute == .landing)
        #expect(gameViewModel.gameState == nil)
    }
    
    // MARK: - Test 2: Input Username
    @Test("Entering username creates game state and navigates to prologue")
    func testEnterUsernameSetsStateAndNavigatesToPrologue() {
        defer { gameViewModel.deleteActiveSave() }
        
        let inputUsername = "michaeldavidsin"
        gameViewModel.enterUsername(inputUsername)
        
        #expect(gameViewModel.currentUsername == inputUsername)
        #expect(gameViewModel.gameState != nil)
        #expect(gameViewModel.currentRoute == .prologue)
    }
    
    // MARK: - Test 3: Start Game & First Post
    @Test("Starting game navigates to timeline and initializes first post")
    func testStartGameNavigatesToTimelineAndLoadsFirstPost() throws {
        defer { gameViewModel.deleteActiveSave() }
        
        gameViewModel.enterUsername("michaeldavidsin")
        
        gameViewModel.startGame(fromRound: 1, startNodeId: "1A")
        
        #expect(gameViewModel.currentRoute == .timeline)
        #expect(!gameViewModel.feedPosts.isEmpty)
        
        let firstPost = try #require(gameViewModel.feedPosts.first)
        #expect(firstPost.nodeId == "first_post")
    }
}
