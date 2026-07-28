//
//  SinglePostPreviewHelper.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 27/07/26.
//

import SwiftUI

struct SinglePostPreviewHelper: View {
    let nodeId: String
    var cropType: CropType = .positive      // 🚨 Toggle between .positive or .negative crop
    var captionIndex: Int = 1              // 🚨 1 for 1st caption, 2 for 2nd caption
                                                                                                                     
    private var loadedData: (node: StoryNode, caption: CaptionOption, quadrant: QuadrantPosition, photoGuard:
                                CropType)? {
        if nodeId == "first_post" || nodeId == "last_post" { return nil }
        guard let roundChar = nodeId.first, let round = Int(String(roundChar)) else {
            return nil
        }
                                                                                                                     
        let fileName = "Round\(round)_Nodes"
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ),
              let data = try? Data(contentsOf: url) else { return nil }
                                                                                                                     
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true
                                                                                                                     
        guard let nodes = try? decoder.decode([StoryNode].self, from: data),
              let node = nodes.first(where: { $0.id == nodeId }) else {
            return nil
        }
                                                                                                                     
        // Select crop based on requested cropType (.positive or .negative)
        let selectedCrop: CropDetails = (
            cropType == .negative
        ) ? node.crops.negativeCrop : node.crops.positiveCrop
        guard !selectedCrop.captions.isEmpty else { return nil }
                                                                                                                     
        // Safely pick 1st caption (index 0) or 2nd caption (index 1)
        let safeIndex = max(
            0,
            min(captionIndex - 1, selectedCrop.captions.count - 1)
        )
        let caption = selectedCrop.captions[safeIndex]
                                                                                                                     
        return (node, caption, selectedCrop.quadrant, cropType)
    }
                                                                                                                     
    var body: some View {
        if nodeId == "first_post" {
            let post = UserPost.openingPost
            SinglePostView(
                imageName: post.imageName,
                quadrant: post.selectedQuadrant,
                username: "johndoe",
                caption: post.selectedCaptionText,
                commentUsername: post.comment?.username ?? "",
                comment: post.comment?.text ?? "",
                date: post.displayDate,
                nodeId: post.nodeId,
                photoGuardType: post.photoGuardResult,
                vibeCheckType: post.vibeCheckResult,
                showComment: true,
                onInsightsTapped: {}
            )
        } else if nodeId == "last_post" {
            let post = UserPost.endingPost
            SinglePostView(
                imageName: post.imageName,
                quadrant: post.selectedQuadrant,
                username: "johndoe",
                caption: post.selectedCaptionText,
                commentUsername: post.comment?.username ?? "",
                comment: post.comment?.text ?? "",
                date: post.displayDate,
                nodeId: post.nodeId,
                photoGuardType: post.photoGuardResult,
                vibeCheckType: post.vibeCheckResult,
                showComment: true,
                onInsightsTapped: {}
            )
        } else if let data = loadedData {
            let t = data.node.timeline
            let dateString = t != nil ? "Year \(t!.year) Semester \(t!.semester) Month \(t!.month)" : "Year 1"
                    
            SinglePostView(
                imageName: data.node.bigPictureId,
                quadrant: data.quadrant,
                username: "johndoe",
                caption: data.caption.text,
                commentUsername: data.caption.comments?.username ?? "",
                comment: data.caption.comments?.text ?? "",
                date: dateString,
                nodeId: data.node.id,
                photoGuardType: data.photoGuard,
                vibeCheckType: data.caption.type,
                showComment: true,
                onInsightsTapped: {}
            )
        } else {
            ContentUnavailableView("Node Not Found", systemImage: "exclamationmark.triangle", description:
                                    Text("Could not find '\(nodeId)' in JSON."))
        }
    }
}
