//
//  Post.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation

// MARK: - Jose (Model yang dipakai json)
public enum CropType: String, Codable, Hashable {
    case positive = "positive"
    case negative = "negative"
}

public enum QuadrantPosition: Int, Codable, CaseIterable, Hashable {
    case topLeft = 1
    case topRight = 2
    case bottomLeft = 3
    case bottomRight = 4
}

public struct Comment: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    let username: String
    let text: String
}

public struct CaptionOption: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    let type: CropType
    let text: String
    let nextNodeId: String
    let comments: Comment?
}

struct CropDetails: Codable, Equatable, Hashable {
    let quadrant: QuadrantPosition
    let captions: [CaptionOption]
}

struct CropsContainer: Codable, Equatable, Hashable {
    let positiveCrop: CropDetails
    let negativeCrop: CropDetails
    
    // perlu mapping supaya nama variabel camelCase Swift bisa baca format snake_case dari JSON
    enum CodingKeys: String, CodingKey {
        case positiveCrop = "positive_crop"
        case negativeCrop = "negative_crop"
    }
}

public struct TimelineData: Codable, Equatable, Hashable {
        public let year: Int
        public let semester: Int
        public let month: Int
}

// MARK: - User Post
public struct UserPost: Codable, Identifiable, Equatable, Hashable {
    public var id: String { nodeId }
    public let nodeId: String
    public let imageName: String
    public let selectedQuadrant: QuadrantPosition
    public let selectedCaptionText: String
    public let comment: Comment?
    public let photoGuardResult: CropType
    public let vibeCheckResult: CropType
    public var isCommentRevealed: Bool? = false
    public let timeline: TimelineData?
    public var displayDate: String {
        if let t = timeline {
            return "Year \(t.year) Semester \(t.semester) Month \(t.month)"
        }
        return "Year 1 Semester 1 Month 1"
    }
    static var openingPost: UserPost {
        UserPost(nodeId: "first_post", imageName: "node_firstPost", selectedQuadrant: .bottomLeft, selectedCaptionText: "First day at as a highschool student.", comment: Comment(id: "com_first_post", username: "doejane", text: "Congrats on your first day!"), photoGuardResult: .positive, vibeCheckResult: .positive, isCommentRevealed: true, timeline: TimelineData(year: 1, semester: 1, month: 1))
    }
    static var endingPost : UserPost {
        UserPost(nodeId: "last_post", imageName: "node_lastPost", selectedQuadrant: .bottomLeft, selectedCaptionText: "End of one journey, beginning of another 🌟💪", comment: Comment(id: "com_last_post", username: "doejane", text: "Congrats on your graduation!"), photoGuardResult: .positive, vibeCheckResult: .positive, isCommentRevealed: true, timeline: TimelineData(year: 3, semester: 2, month: 6))
    }
    
}

public struct StoryNode: Identifiable, Codable, Hashable {
    public let id: String
    let round: Int
    let bigPictureId: String
    let crops: CropsContainer
    
    let timeline: TimelineData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case round
        case bigPictureId = "big_picture_id"
        case crops
        case timeline
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

