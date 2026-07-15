//
//  Post.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

// MARK: - Jose (Model yang dipakai json)
enum CropType: String, Codable {
    case positive = "positive"
    case negative = "negative"
}

enum QuadrantPosition: Int, Codable {
    case topLeft = 1
    case topRight = 2
    case bottomLeft = 3
    case bottomRight = 4
}

struct Comment: Identifiable, Codable, Equatable {
    let id: String
    let username: String
    let text: String
}

struct CaptionOption: Identifiable, Codable, Equatable {
    let id: String
    let type: CropType
    let text: String
    let nextNodeId: String
    let comments: [Comment]
}

struct CropDetails: Codable {
    let quadrant: QuadrantPosition
    let captions: [CaptionOption]
}

struct CropsContainer: Codable {
    let positiveCrop: CropDetails
    let negativeCrop: CropDetails
    
    // perlu mapping supaya nama variabel camelCase Swift bisa baca format snake_case dari JSON
    enum CodingKeys: String, CodingKey {
        case positiveCrop = "positive_crop"
        case negativeCrop = "negative_crop"
    }
}

struct ScenarioNode: Identifiable, Codable {
    let id: String
    let round: Int
    let bigPictureId: String
    let crops: CropsContainer
    
    enum CodingKeys: String, CodingKey {
        case id
        case round
        case bigPictureId = "big_picture_id"
        case crops
    }
}

// MARK: - Fany
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
