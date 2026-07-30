//
//  FeedViewModel.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

extension GameViewModel {
    // MARK: - Computer Properties
    
    public var feedPosts: [UserPost] {
        return Array((gameState?.publishedPosts ?? []).reversed())
    }
    
    public func markCommentAsRevealed(for postID: String) {
        guard var state = self.gameState else { return }
        
        if let index = state.publishedPosts.firstIndex(where: {$0.id == postID}) {
            state.publishedPosts[index].isCommentRevealed = true
            self.gameState = state
            
            storageController.saveGame(state)
        }
    }
}
