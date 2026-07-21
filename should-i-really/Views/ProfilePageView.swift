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
        repeating: GridItem(.flexible(), spacing: 1),
        count: 3
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
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.black)
                                .accessibilityLabel("Home Button")
                        }

                        Spacer()
                    }
                    HStack() {
                        Spacer()
                        Text(gameViewModel.currentUsername ?? "johndoe")
                            .fontWeight(.bold)
                            .font(.headline)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                    
                // MARK: - Profile Picture + Timeline
                ScrollView {
                    HStack {
                        Image("pp")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .accessibilityLabel("My Profile Picture")
                        Spacer()
                        Text("Year 1 Semester 1 Month 1")
                            .font(.callout)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    //            .border(.blue)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                        
                    //MARK: - Bio
                    Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                    )
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //            .border(.brown)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                        
                    //MARK: - Grid Icon
                    Image(systemName: "square.grid.3x3.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        
                        
                    //MARK: - Posts Feed Preview
                    LazyVGrid(columns: gridColumns, spacing: 1) {
                        ForEach(gameViewModel.feedPosts) { node in
                            NavigationLink(value: GameViewModel.GameRoute.feedView(postID: node.id)) {
                                Color.clear
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .overlay {
                                        GeometryReader { geo in
                                            if node.nodeId == "first_post" || node.nodeId == "last_post" {
                                                Image(node.imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: geo.size.width, height: geo.size.height)    
                                                    .clipped()
                                            } else {
                                                QuadrantImageView(
                                                    imageName: node.imageName,
                                                    quadrant: node.selectedQuadrant,
                                                    size: geo.size.width
                                                )
    
                                            }
                                            
                                        }
                                }
                                .contentShape(Rectangle())
                                .clipped()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //MARK: - Add Post Button
            let isGameFinished = gameViewModel.lastEndingId != nil
            let hasInjectedGameEnding = gameViewModel.feedPosts.contains(where: {$0.nodeId == "last_post"})
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
                } else if (isGameFinished && !hasInjectedGameEnding) {
                    Button {
                        gameViewModel.injectEndingPost()
                        gameViewModel.navigationPath.append(.feedView(postID: "last_post"))
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                } else {
                    Button {
                        isShowingPostFlow = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingPostFlow) {
            PostCreationFlowView { newPostID in
                isShowingPostFlow = false
                
                DispatchQueue.main.asyncAfter(deadline:.now() + 0.3) {
                    gameViewModel.navigationPath.append(.feedView(postID: newPostID))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let dummyVM = GameViewModel()
    dummyVM.startGame(fromRound: 1, startNodeId: "1A")
    
    return ProfilePageView()
        .environment(dummyVM)
}

