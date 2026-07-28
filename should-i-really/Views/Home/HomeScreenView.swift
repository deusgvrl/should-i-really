//
//  HomeScreenView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct HomeScreenView: View {
    @Environment(GameViewModel.self) private var viewModel
    @State private var showOverwriteAlert: Bool = false
    
    // MARK: - Body
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                // MARK: - Layer Background Asset
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(maxHeight: 150)
                    
                    // MARK: - Logo Should I Really
                    Image("HomeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 160)
                        .padding(.bottom, 32)
                    
                    // MARK: - Landing Menu Buttons Hierarchy
                    LandingMenuView(viewModel: viewModel, showOverwriteAlert: $showOverwriteAlert)
                    
                    Spacer()
                }
                .padding(.horizontal, 28)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.openArchive()
                    }) {
                        Image(systemName: "text.book.closed.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .tint(.buttonBrown)
                    .accessibilityLabel("Archive")
                    .accessibilityInputLabels(["Archive"])
                }
            }
            
            .customAlert(
                isPresented: $showOverwriteAlert,
                title: "Start a New Game?",
                message: "Starting a new game will\noverwrite your current progress",
                cancelTitle: "Cancel",
                confirmTitle: "Overwrite"
            ) {
                viewModel.deleteActiveSave()
                viewModel.startNewGame()
            }
            
            // MARK: - Nav Destination
            .navigationDestination(for: GameViewModel.GameRoute.self) { route in
                Group {
                    switch route {
                    case .usernameInput:
                        UsernameInputView()
                    case .prologue:
                        PrologView()
                    case .archive:
                        ArchiveView()
                    case .timeline:
                        ProfilePageView()
                    case .feedView(let postID):
                        ProfileFeedView(initialPostID: postID)
                    case .ending:
                        if let endingId = viewModel.lastEndingId {
                            EndingSummaryView(endingId: endingId)
                        } else {
                            EndingSummaryView(endingId: "ENDING_1")
                        }
                    case .archivedEnding(let endingId):
                        EndingSummaryView(endingId: endingId, isArchivePreview: true)
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreenView()
        .environment(GameViewModel())
}
