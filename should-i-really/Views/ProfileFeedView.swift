//
//  ProfileFeedView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct ProfileFeedView: View {
    @Environment(GameViewModel.self) private var viewModel
    
    let initialPostID: String?
    
    @State private var scrollPosition: String? = nil
    @State private var commentsVisible: Bool = false
    
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
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text("Posts").font(.subheadline).bold()
                    Text("johndoe")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .bold()
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestPermissionAndSchedule()
                    
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                    commentsVisible = true
                }
            }
                    
            if let targetID = initialPostID {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollPosition = targetID
                    }
                }
            }
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
            photoGuardType: post.photoGuardResult,
            vibeCheckType: post.vibeCheckResult,
            showComment: !isNewestPost ? true : commentsVisible
        )
    }
}

#Preview {
    ProfileFeedView(initialPostID: "5")
        .environment(GameViewModel())
}
