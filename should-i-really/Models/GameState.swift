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
    
    // MARK: - Initializer
    public init(username: String){
        self.username = username
    }
}
