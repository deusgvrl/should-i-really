//
//  CaptionSelectionView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct CaptionSelectionView: View {
    
    // MARK: - Dependencies (Using Modern @Observable Pattern)
    @Environment(PostCreationViewModel.self) var viewModel
    @Environment(GameViewModel.self) private var gameViewModel
    @Environment(\.dismiss) private var dismissAction
    
    @State private var isUploading = false

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // MARK: Selected Photo Display
                selectedImageArea
                
                // MARK: Captions List
                ScrollView(showsIndicators: false) {
                    captionChoicesContainer
                }
                
                Spacer()
            }
            
            if isUploading {
                UploadingView(uploadDuration: 2.0) {
                    viewModel.finalizeAndPost()
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        gameViewModel.currentRoute = .timeline
                        gameViewModel.isPresentingPostCreation = false
                        viewModel.navigateToCaptionScreen = false
                    }
                }
                .ignoresSafeArea()
                .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        // MARK: - Toolbar Setup
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.navigateToCaptionScreen = false
                    dismissAction()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Choose Your Caption")
                    .font(.headline)
                    .foregroundColor(.textBrown)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    guard viewModel.selectedCaption != nil else { return }
                    withAnimation {
                        isUploading = true
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .font(.body.weight(.bold))
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(viewModel.selectedCaption != nil ? .buttonBrown : .unselectedGray)
                .id(viewModel.selectedCaption != nil)
                .accessibilityLabel("Post")
                .accessibilityInputLabels(["Post"])
            }
        }
    }
    
    // MARK: - Subviews
    
    //    /// Displays the 1:1 scaled-up version of the user's selected quadrant
    private var selectedImageArea: some View {
        ZStack {
            if let selectedQuadrant = viewModel.selectedQuadrant {
                GeometryReader { geo in
                    QuadrantImageView(
                        imageName: viewModel.currentImageName,
                        quadrant: selectedQuadrant,
                        size: geo.size.width
                    )
                }
                .aspectRatio(1.0, contentMode: .fit)
            } else {
                // Fallback UI if no quadrant is active
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                            Text("No Photo Selected")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    )
            }
        }
        .aspectRatio(1.0, contentMode: .fill)
    }
    
    private var captionChoicesContainer: some View {
        VStack(spacing: 16) {
            ForEach(Array(viewModel.availableCaptions.enumerated()), id: \.element.id) { index, caption in
                let isSelected = viewModel.selectedCaption?.id == caption.id
                let captionNumber = index + 1
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectCaption(caption)
                    }
                }) {
                    Text(caption.text)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.buttonBrown : Color.unselectedGray)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.borderBrown, lineWidth: 3)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Caption \(captionNumber)")
                .accessibilityInputLabels(["Caption \(captionNumber)"])
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedCaption)
    }
}

//// MARK: - Preview Generator
#Preview {
    let gameViewModel = GameViewModel()
    let postViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
    
    postViewModel.selectedQuadrant = .topLeft
    
    return NavigationStack {
        CaptionSelectionView()
            .environment(postViewModel)
    }
}
