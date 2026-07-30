//
//  UnlockedEndings.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 16/07/26.
//

import Foundation
import SwiftData

// Create Schema
@Model
class UnlockedEndings {
    // MARK: - Attributes
    @Attribute(.unique) var endingId: String
    var unlockedAt: Date
    
    // MARK: - Init
    
    init(endingId: String, unlockedAt: Date) {
        self.endingId = endingId
        self.unlockedAt = unlockedAt
    }
}
