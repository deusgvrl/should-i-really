//
//  PostCreationPostView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 17/07/26.
//

import SwiftUI

struct PostCreationFlowView: View {
    @Environment(GameViewModel.self) private var gameViewModel
    @Environment(\.dismiss) private var dismissModal
    
    @State private var postViewModel: PostCreationViewModel?
    
    var body: some View {
        Group {
            if let viewModel = postViewModel {
                NavigationStack {
                    PhotoSelectionView()
                        .environment(viewModel)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if postViewModel == nil {
                let newViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
                
                newViewModel.onPostFinished = {
                    dismissModal()
                }
                
                postViewModel = newViewModel
            }
        }
    }
}
