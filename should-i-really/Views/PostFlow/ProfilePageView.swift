//
//  ProfilePageView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 14/07/26.
//

import SwiftUI

struct ProfilePageView: View {
    @Environment(GameViewModel.self) private var gameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingPauseMenu = false
    
    @State private var displayedTimeline: TimelineData? = nil

    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
        
    var body: some View {
        @Bindable var gameViewModel = gameViewModel
        
        ZStack {
            VStack() {
                // MARK: - Top Bar (Username + Home Button)
                ZStack {
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isShowingPauseMenu = true
                            }
                        } label: {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 28, height: 24)
                                .foregroundStyle(.textBrown)
                                .accessibilityLabel("Home")
                        }

                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        Text(gameViewModel.currentUsername ?? "johndoe")
                            .fontWeight(.bold)
                            .font(.body)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                    
                // MARK: - Profile Picture + Timeline
                ScrollView {
                    HStack(alignment:.center, spacing: 16) {
                        Image("icon_profilePicture")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .accessibilityLabel("My Profile Picture")
                        Spacer()
                        // MARK: - Progress Bar Timeline
                        SegmentedTimelineView(
                            timeline: displayedTimeline,
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                        
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        
                    
                    //MARK: - Posts Feed Preview
                    let totalPosts = gameViewModel.feedPosts.count
                    LazyVGrid(columns: gridColumns, spacing: 16) {
                        ForEach(
                            Array(gameViewModel.feedPosts.enumerated()),
                            id: \.element.id
                        ) { index, node in
                            let postNumber = totalPosts - index
                            let currentOrnament: String? = {
                                if let order = gameViewModel.gameState?.ornamentsOrder,
                                   !order.isEmpty {
                                    switch postNumber {
                                    case 2: return order[0]
                                    case 3: return order[1]
                                    case 6: return order[2]
                                    case 7: return order[0]
                                    default: return nil
                                    }
                                }
                                return nil
                            }()
                            
                            NavigationLink(
                                value: GameViewModel.GameRoute
                                    .feedView(postID: node.id)
                            ) {
                                Color.clear
                                    .aspectRatio(0.83, contentMode: .fill)
                                    .overlay {
                                        GeometryReader { geo in
                                            SinglePreviewView(
                                                node: node,
                                                size: geo.size,
                                                ornament: currentOrnament
                                            )
                                        }
                                        .contentShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                    }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(postNumber)")
                            .accessibilityInputLabels(["Post \(postNumber)"])
                            .simultaneousGesture(TapGesture().onEnded {
                                AudioController.shared.playSFX(filename: "tap")
                            })
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //MARK: - Add Post Button
            let isGameFinished = gameViewModel.lastEndingId != nil
            let hasInjectedGameEnding = gameViewModel.feedPosts.contains(
                where: {$0.nodeId == "last_post"
                })
            VStack {
                Spacer()
                
                let isGameFinished = gameViewModel.lastEndingId != nil
                let hasInjectedGameEnding = gameViewModel.feedPosts.contains(
                    where: { $0.nodeId == "last_post"
                    })
                  
                Button {
                    if isGameFinished && hasInjectedGameEnding {
                        gameViewModel.navigationPath.append(.ending)
                        AudioController.shared.playSFX(filename: "tap")
                    
                    } else if isGameFinished && !hasInjectedGameEnding {
                        withAnimation(
                            .spring(response: 0.5, dampingFraction: 0.75)
                        ) {
                            gameViewModel.injectEndingPost()
                        }
                        Task {
                            try? await Task.sleep(for: .seconds(0.5))
                            withAnimation(
                                .spring(response: 0.8, dampingFraction: 0.7)
                            ) {
                                displayedTimeline = gameViewModel.feedPosts.first?.timeline
                            }
                        }
                        AudioController.shared.playSFX(filename: "congrats")
                        HapticsController.shared
                            .playContinuousHaptic(duration: 1.0)
                    
                    } else {
                        gameViewModel.isPresentingPostCreation = true
                        AudioController.shared.playSFX(filename: "tap")
                    }
                } label: {
                    Image(
                        systemName: isGameFinished && hasInjectedGameEnding ? "chevron.right" : "plus"
                    )
                    .fontDesign(.default)
                    .font(.system(size: 32, weight: .regular))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.buttonBrown)
                    .clipShape(Circle())
                }
                .accessibilityLabel(
                    isGameFinished && hasInjectedGameEnding ? "Next" : "Add"
                )
                .accessibilityInputLabels([isGameFinished && hasInjectedGameEnding ? "Next" : "Add Post"])
            }
            if isShowingPauseMenu {
                PauseMenuOverlayView(isPresented: $isShowingPauseMenu)
                    .zIndex(100)
            }
        }
        .fullScreenCover(isPresented: $gameViewModel.isPresentingPostCreation) {
            PostCreationFlowView { newPostID in
                Task {
                    await gameViewModel.navigateToFeed(postID: newPostID)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if displayedTimeline == nil {
                displayedTimeline = gameViewModel.feedPosts.first?.timeline
            }
        }
        .onChange(of: gameViewModel.navigationPath) {
            oldPath,
            newPath in
            let latestTimeline = gameViewModel.feedPosts.first?.timeline
                        
            let wasOnFeed = oldPath.contains(where: {
                if case .feedView = $0 { return true }
                return false
            })
            let isNowOnProfile = !newPath.contains(where: {
                if case .feedView = $0 { return true }
                return false
            })
                        
            if wasOnFeed && isNowOnProfile && displayedTimeline != latestTimeline {
                print(
                    "🎯 [ANIMATION] Popped back from FeedView! Animating timeline..."
                )
                Task {
                    try? await Task.sleep(for: .seconds(0.4))
                    withAnimation(
                        .spring(response: 0.8, dampingFraction: 0.7)
                    ) {
                        displayedTimeline = latestTimeline
                    }
                }
            } else if displayedTimeline == nil {
                displayedTimeline = latestTimeline
            }
        }
    }
}

#Preview {
    let dummyVM: GameViewModel = {
        let vm = GameViewModel()
        vm.enterUsername("PreviewPlayer")
        
        if var state = vm.gameState {
            for i in 1...5 {
                let dummyPost = UserPost(
                    nodeId: "\(i)A",
                    imageName: "SampleImage5",
                    selectedQuadrant: .topLeft,
                    selectedCaptionText: "This is a fake caption for round \(i)!",
                    comment: Comment(
                        id: "\(i)",
                        username: "bestie",
                        text: "Omg so cool!"
                    ),
                    photoGuardResult: .positive,
                    vibeCheckResult: .positive,
                    timeline: TimelineData(year: 2, semester: 2, month: 2)
                )
                state.publishedPosts.append(dummyPost)
            }
            vm.gameState = state
        }
        
        return vm
    }()
    
    
    ProfilePageView()
        .environment(dummyVM)
}
