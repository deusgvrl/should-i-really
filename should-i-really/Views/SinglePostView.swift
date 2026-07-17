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
    
    var photoGuardScore: Int = 1
    var vibeCheckScore: Int = 0
    var showComment: Bool

    @State private var showInsights = false
    
    var body: some View {
        
        // MARK: - Design System Constants
        let activeColor = Color(red: 173/255, green: 127/255, blue: 94/255) // Brown
        
        VStack(alignment: .leading,spacing: 8) {
            //MARK: Profile Pict + Username
            HStack(spacing: 16) {
                Image("pp")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                    .padding(.leading, 8)
                Text(username)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            //MARK: Post Image
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    GeometryReader { geo in
                        QuadrantImageView(imageName: imageName, quadrant: quadrant, size: geo.size.width)
                    }
                }
            .clipped()
//            Image(imageName)
//                .resizable()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .aspectRatio(1, contentMode: .fit)
            
            //MARK: View Insights Button
            
            Button (action: {
                showInsights = true}) {
                    HStack(spacing: 4) {
                        Image(systemName: "aqi.medium.gauge.open")
                            .font(.subheadline)
                            .foregroundStyle(activeColor)
                        Text("View insights")
                            .font(.subheadline)
                            .foregroundStyle(activeColor)
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 4)
                }
            
            Divider()
            //MARK: Share Deck Icons
            Image("Share Deck")
                .resizable()
                .frame(width: 115, height: 27)
                .padding(.leading, 4)
            
            //MARK: Caption
            Text("**\(username)** \(caption)")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.leading, 8)
                .padding(.trailing, 4)
            
            //MARK: Comment
            if showComment {
                VStack(alignment: .leading, spacing: 4) {
                    Text("**\(commentUsername)** \(comment)")
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
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
        // MARK: - Sheet Integration
        .sheet (isPresented: $showInsights) {
            InsightsOverlayView(
                framingScore: photoGuardScore,
                captionScore: vibeCheckScore
            )
            .presentationDetents([.fraction(0.45)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    SinglePostView(
        imageName: "1",
        quadrant: .bottomLeft,
        username: "johndoe",
        caption: "Seeing this disappointment hurts, but your incredible worth and intelligence are so much bigger than a letter in your hands! 🌟💪",
        commentUsername: "doejane",
        comment: "I'm so proud of you, you're going to do great things!",
        date: "Year 3 Semester 1 Month 1",
        showComment: true
    )
}
