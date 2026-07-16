//
//  Post.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

// MARK: - Jose (Model yang dipakai json)
enum CropType: String, Codable, Hashable {
    case positive = "positive"
    case negative = "negative"
}

enum QuadrantPosition: Int, Codable, CaseIterable, Hashable {
    case topLeft = 1
    case topRight = 2
    case bottomLeft = 3
    case bottomRight = 4
}

struct Comment: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let username: String
    let text: String
}

struct CaptionOption: Identifiable, Codable, Equatable, Hashable {
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

struct StoryNode: Identifiable, Codable {
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
    
    var imageName: String {
        return bigPictureId
    }
        
    var activeQuadrants: Set<QuadrantPosition> {
        return [crops.positiveCrop.quadrant, crops.negativeCrop.quadrant]
    }
        
    var options: [QuadrantPosition: [CaptionOption]] {
        var dict = [QuadrantPosition: [CaptionOption]]()
        dict[crops.positiveCrop.quadrant] = crops.positiveCrop.captions
        dict[crops.negativeCrop.quadrant] = crops.negativeCrop.captions
        return dict
    }
}

