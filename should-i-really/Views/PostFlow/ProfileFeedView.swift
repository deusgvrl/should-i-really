//
//  ProfileFeedView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct ProfileFeedView: View {
    @Environment(GameViewModel.self) private var viewModel
    
    @State private var selectedPostForInsights: UserPost? = nil
    
    let initialPostID: String?
    
    @State private var scrollPosition: String? = nil
    
    init(initialPostID: String? = nil) {
        self.initialPostID = initialPostID
    }
    
    var body: some View {
        //MARK: Timeline Feed View
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.feedPosts) { post in
                    buildPostView(for: post)
                        .id(post.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition, anchor: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("Posts").font(.subheadline).bold()
                    Text(viewModel.gameState?.username ?? "johndoe")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .bold()
                }
            }
        }
        .task {
            if let targetID = initialPostID {
                scrollPosition = targetID
            }
            
            if let newestPost = viewModel.feedPosts.first, !(newestPost.isCommentRevealed ?? false) {
                
                NotificationManager.shared.requestPermissionAndSchedule()
                
                try? await Task.sleep(for: .seconds(5))
                
                withAnimation(.spring(response:0.45 , dampingFraction: 0.75)) {
                    viewModel.markCommentAsRevealed(for: newestPost.id)
                }
            }
        }
        .sheet(item: $selectedPostForInsights) { post in
            InsightsOverlayView(framingType: post.photoGuardResult, captionType: post.vibeCheckResult)
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.visible)
        }
            
    }
    
    // MARK: - Subview Builder
    @ViewBuilder
    private func buildPostView(for post: UserPost) -> some View {
        let isNewestPost = (post.id == viewModel.feedPosts.first?.id)
        
        SinglePostView(
            imageName: post.imageName,
            quadrant: post.selectedQuadrant,
            username: viewModel.gameState?.username ?? "johndoe",
            caption: post.selectedCaptionText,
            commentUsername: post.comment?.username ?? "",
            comment: post.comment?.text ?? "",
            date: "Year 3 Semester 1 Month 1",
            nodeId: post.nodeId,
            photoGuardType: post.photoGuardResult,
            vibeCheckType: post.vibeCheckResult,
            showComment: !isNewestPost ? true : (post.isCommentRevealed ?? false),
            onInsightsTapped: {
                print("🎯 DEBUG: Button tapped for node: \(post.nodeId)")
                self.selectedPostForInsights = post
            }
        )
    }
}

#Preview {
    ProfileFeedView(initialPostID: "5")
        .environment(GameViewModel())
}
