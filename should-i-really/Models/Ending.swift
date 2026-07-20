//
//  Ending.swift
//  should-i-really
//
//  Created by Michael David Sin on 20/07/26.
//

import Foundation

public struct EndingNode: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public let title: String
    public let imageName: String
    public let mainDescription: String
    public let photoTraitTitle: String
    public let photoTraitDesc: String
    public let captionTraitTitle: String
    public let captionTraitDesc: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageName = "image_name"
        case mainDescription = "main_description"
        case photoTraitTitle = "photo_trait_title"
        case photoTraitDesc = "photo_trait_desc"
        case captionTraitTitle = "caption_trait_title"
        case captionTraitDesc = "caption_trait_desc"
    }
}
