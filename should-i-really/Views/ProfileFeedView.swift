//
//  ProfileFeedView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct ProfileFeedView: View {
    let posts: [String]
    
    @State private var scrollPosition: String?
    
    init(posts: [String], initialPostID: String? = nil) {
        self.posts = posts
        self._scrollPosition = State(initialValue: initialPostID)
    }
    
    var body: some View {
        //MARK: Timeline Feed View
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(posts, id: \.self) { post in
                    SinglePostView(
                        imageName: post,
                        username: "johndoe",
                        caption: "Seeing this disappointment hurts, but your incredible worth and intelligence are so much bigger than a letter in your hands! 🌟💪",
                        commentUsername: "doejane",
                        comment: "I'm so proud of you, you're going to do great things!",
                        date: "Year 3 Semester 1 Month 1")
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //MARK: Top Description (Posts: Username)
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("Posts")
                        .font(.subheadline)
                        .bold()
                    Text("johndoe")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    ProfileFeedView(posts: ["7", "6", "5", "4", "3", "2", "1"], initialPostID: "5")
}
