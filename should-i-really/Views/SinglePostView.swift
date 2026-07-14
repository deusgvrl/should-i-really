//
//  SinglePostView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 14/07/26.
//

import SwiftUI

struct SinglePostView: View {
    var imageName: String
    let username: String
    let caption: String
    let commentUsername: String
    let comment: String
    let date: String
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 8) {
            //MARK: Profile Pict + Username
            HStack(spacing: 16) {
                Image("pp")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(.leading, 8)
                Text(username)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            //MARK: Post Image
            Image(imageName)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
            
            //MARK: View Insights
            HStack(spacing: 4) {
                Image(systemName: "aqi.medium.gauge.open")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .padding(.leading, 8)
                Text("View insights")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
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
            Text("**\(commentUsername)** \(comment)")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 8)
                            .padding(.trailing, 4)
            Text(date)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
    }
}

#Preview {
    SinglePostView(
        imageName: "1",
        username: "johndoe",
        caption: "Seeing this disappointment hurts, but your incredible worth and intelligence are so much bigger than a letter in your hands! 🌟💪",
        commentUsername: "doejane",
        comment: "I'm so proud of you, you're going to do great things!",
        date: "Year 3 Semester 1 Month 1"
    )
}
