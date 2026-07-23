//
//  SinglePostView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 14/07/26.
//

import SwiftUI

struct SinglePostView: View {
    let imageName: String
    let quadrant: QuadrantPosition
    let username: String
    let caption: String
    let commentUsername: String
    let comment: String
    let date: String
    let nodeId: String
    
    let photoGuardType: CropType
    let vibeCheckType: CropType
    var showComment: Bool

    var onInsightsTapped: (() -> Void)
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 8) {
            //MARK: Profile Pict + Username
            HStack(spacing: 16) {
                Image("icon_miniProfilePicture")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .padding(.leading, 8)
                Text(username)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .tracking(-1)
            }
            
            //MARK: Post Image
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    GeometryReader { geo in
                        if nodeId == "first_post" || nodeId == "last_post" {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                        } else {
                            QuadrantImageView(imageName: imageName, quadrant: quadrant, size: geo.size.width)
                            
                        }
                    }
                }
                .contentShape(Rectangle())
            .clipped()

            
            //MARK: View Insights Button
            if nodeId != "first_post" && nodeId != "last_post" {
                Button (action: {
                    onInsightsTapped()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "aqi.medium.gauge.open")
                            .font(.subheadline)
                        Text("View insights")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .zIndex(100)
                .accessibilityLabel("View Insights")
                .accessibilityInputLabels(["Insights"])

                Divider()
            }
            
            //MARK: Share Deck Icons
            Image("icon_likeAndShare")
                .resizable()
                .frame(width: 67, height: 28)
                .padding(.leading, 4)
            
            
            //MARK: Caption
            let usernameText = Text("\(username)")
                .fontWeight(.bold)
            
            let captionText = Text("\(caption)")
                .fontWeight(.regular)
            
            Text("**\(usernameText)** \(captionText)")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.leading, 8)
                .padding(.trailing, 4)
            
            //MARK: Comment
            if showComment {
                let commentUsernameText = Text("\(commentUsername)")
                    .fontWeight(.bold)
                let commentText = Text("\(comment)")
                    .fontWeight(.regular)
                VStack(alignment: .leading, spacing: 4) {
                    Text("**\(commentUsernameText)** \(commentText)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                        .padding(.trailing, 4)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                
                .allowsHitTesting(false)
                .disabled(true)
            }
            
            Text(date)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
    }
}

#Preview {
    SinglePostView(
        imageName: "node_1",
        quadrant: .bottomLeft,
        username: "johndoe",
        caption: "Seeing this disappointment hurts, but your incredible worth and intelligence are so much bigger than a letter in your hands! 🌟💪",
        commentUsername: "doejane",
        comment: "I'm so proud of you, you're going to do great things!",
        date: "Year 3 Semester 1 Month 1",
        nodeId: "1A",
        photoGuardType: .negative,
        vibeCheckType: .positive,
        showComment: true,
        onInsightsTapped: {
            
        }
    )
}
