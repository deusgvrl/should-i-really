//
//  ProfileFeedView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct ProfileFeedView: View {
    @Environment(GameViewModel.self) private var viewModel
    
    var posts = ["7", "6", "5", "4", "3", "2", "1"]
    @State private var scrollPosition: String?
    
    init(initialPostID: String? = nil) {
        self._scrollPosition = State(initialValue: initialPostID)
    }
    
    var body: some View {
        //MARK: Timeline Feed View
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(posts, id: \.self) { post in
                    buildPostView(for: post)
                    //                ForEach(viewModel.feedPosts) { post in
                    //                    SinglePostView(
                    //                        imageName: post.imageName,
                    //                        username: viewModel.gameState?.username ?? "johndoe",
                    //                        caption: post.selectedCaptionText,
                    //                        commentUsername: post.comments.username,
                    //                        comment: post.comments.text,
                    //                        date: "Year 3 Semester 1 Month 1")
                    
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("Posts").font(.subheadline).bold()
                    Text("johndoe").font(.caption).foregroundStyle(.secondary).bold()
                }
            }
        }
    }
    
    // MARK: - Subview Builder
    @ViewBuilder
    private func buildPostView(for post: String) -> some View {
        let metrics = getDummyMetrics(for: post)
        
        SinglePostView(
            imageName: post,
            username: "johndoe",
            caption: "Seeing this disappointment hurts, but your incredible worth and intelligence are so much bigger than a letter in your hands! 🌟💪",
            commentUsername: "doejane",
            comment: "I'm so proud of you, you're going to do great things!",
            date: "Year 3 Semester 1 Month 1",
            photoGuardScore: metrics.framingScore,
            vibeCheckScore: metrics.captionScore
        )
    }
    
    // MARK: - Dummy Metrics
    private func getDummyMetrics(for postImageName: String) -> (framingScore: Int, captionScore: Int) {
        switch postImageName {
        case "7": return (framingScore: 1, captionScore: 1)
        case "6": return (framingScore: 0, captionScore: 1)
        case "5": return (framingScore: 1, captionScore: 0)
        case "4": return (framingScore: 0, captionScore: 0)
        case "3": return (framingScore: 1, captionScore: 1)
        case "2": return (framingScore: 0, captionScore: 1)
        default:  return (framingScore: 1, captionScore: 0)
        }
    }
}

#Preview {
    ProfileFeedView(initialPostID: "5")
        .environment(GameViewModel())
}
