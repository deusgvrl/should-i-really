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
    
    @State private var isShowingPostFlow = false

    private let gridColumns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
        
    var body: some View {
        
        ZStack {
            VStack() {
                // MARK: - Top Bar (Username + Home Button)
                ZStack {
                    HStack {
                        Button {
                            gameViewModel.navigationPath.removeAll()
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
                    HStack(alignment:.center) {
                        Image("icon_profilePicture")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .accessibilityLabel("My Profile Picture")
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(gameViewModel.feedPosts.first?.displayDate ?? "Year 1 Semester 1 Month 1")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("I think therefore i am")
                                .font(.body)
                                .fontWeight(.regular)
                        }
                        .padding(.vertical, 12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                        

                        
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        
                    
                    //MARK: - Posts Feed Preview
                    let totalPosts = gameViewModel.feedPosts.count
                    LazyVGrid(columns: gridColumns, spacing: 16) {
                        ForEach(Array(gameViewModel.feedPosts.enumerated()), id: \.element.id) { index,node in
                            let postNumber = totalPosts - index
                            var currentOrnament: String? = nil
                            
                            if let order = gameViewModel.gameState?.ornamentsOrder, !order.isEmpty {
                                switch postNumber {
                                case 2: currentOrnament = order[0]
                                case 3: currentOrnament = order[1]
                                case 6: currentOrnament = order[2]
                                case 7: currentOrnament = order[0]
                                default: currentOrnament = nil
                                }
                            }
                            
                            return NavigationLink(
                                value: GameViewModel.GameRoute
                                    .feedView(postID: node.id)
                            ) {
                                Color.clear
                                    .aspectRatio(0.83, contentMode: .fill)
                                    .overlay {
                                        GeometryReader { geo in
                                            SinglePreviewView(node: node, size: geo.size, ornament: currentOrnament)
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: 12))
                                    }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(postNumber)")
                            .accessibilityInputLabels(["Post \(postNumber)"])
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
                
                if (isGameFinished && hasInjectedGameEnding) {
                    Button {
                        gameViewModel.navigationPath.append(.ending)
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    .accessibilityLabel("Next")
                    .accessibilityInputLabels(["Next"])
                } else if (isGameFinished && !hasInjectedGameEnding) {
                    Button {
                        gameViewModel.injectEndingPost()
                        gameViewModel.navigationPath
                            .append(.feedView(postID: "last_post"))
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                    .accessibilityLabel("Add")
                    .accessibilityInputLabels(["Add Post"])
                } else {
                    Button {
                        isShowingPostFlow = true
                    } label: {
                        Image(systemName: "plus")
                            .fontDesign(.default)
                            .font(.system(size: 32, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.buttonBrown)
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Add")
                    .accessibilityInputLabels(["Add Post"])
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingPostFlow) {
            PostCreationFlowView { newPostID in
                isShowingPostFlow = false
                
                DispatchQueue.main.asyncAfter(deadline:.now() + 0.3) {
                    gameViewModel.navigationPath
                        .append(.feedView(postID: newPostID))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
                    comment: Comment(id: "\(i)", username: "bestie", text: "Omg so cool!"),
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

