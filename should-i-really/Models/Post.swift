//
//  Post.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

public enum Quadrant: Int, CaseIterable {
    case topLeft = 0
    case topRight = 1
    case bottomLeft = 2
    case bottomRight = 3
}

public struct PlayerChoice: Hashable {
    public let quadrant: Quadrant
    public let captionIndex: Int
    
    public init(quadrant: Quadrant, captionIndex: Int) {
        self.quadrant = quadrant
        self.captionIndex = captionIndex
    }
}

public struct StoryNode {
    public let id: String
    public let imageName: String
    public let activeQuadrants: Set<Quadrant>
    public let quadrantCaptions: [Quadrant: [String]]
    public let nextNodePaths: [PlayerChoice: String]
}
