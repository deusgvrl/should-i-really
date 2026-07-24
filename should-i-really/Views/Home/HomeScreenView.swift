//
//  HomeScreenView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct HomeScreenView: View {
    // Call viewModel to manage routes
    //        @Bindable var viewModel: GameViewModel
    
    // Local state var
    @Environment(GameViewModel.self) private var viewModel
    
    
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
                        .frame(maxHeight: 170)
                    
                    // MARK: - Logo Should I Really
                    Image("HomeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 160)
                        .padding(.bottom, 32)
                    
                    // MARK: - Landing Menu Buttons Hierarchy
                    LandingMenuView(viewModel: viewModel)
                    
                    Spacer()
                }
                .padding(.horizontal, 28)
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
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
            }
        }
    }
}


#Preview {
    HomeScreenView()
        .environment(GameViewModel())
}
