//
//  GameState.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

// MARK: - Game State Model
/// Data structure representing player's profile 
public struct GameState: Codable, Equatable {
    // MARK: - Properties
    public var username: String
    public var currentRound: Int
    public var currentNodeId: String
    
    public var publishedPosts: [UserPost]
    
    // MARK: - Initializer
    public init(username: String, currentRound: Int = 1, currentNodeId: String = "1A", publishedPosts: [UserPost] = []){
        self.username = username
        self.currentRound = currentRound
        self.currentNodeId = currentNodeId
        self.publishedPosts = publishedPosts
    }
}
