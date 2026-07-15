//
//  CaptionSelectionView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct CaptionSelectionView: View {
    
    // MARK: - Dependencies (Using Modern @Observable Pattern)
    var viewModel: PostCreationViewModel
    @Environment(\.dismiss) private var dismissAction
    
    // MARK: - Design System Constants
    private let activeColor = Color(red: 173/255, green: 127/255, blue: 94/255) // Brown
    private let inactiveColor = Color(red: 182/255, green: 182/255, blue: 182/255) // Grey
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            //MARK: Photo
            selectedImageArea
                .padding(.top, 40)
            
            ScrollView {
                captionChoicesContainer
            }
            
            Spacer()
        }
        .ignoresSafeArea(edges: .horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: - Toolbar Setup
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Choose Your Caption")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(width: 30, height: 44, alignment: .center)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.finalizeAndPost()
                    
                    withAnimation(.easeInOut) {
                        viewModel.navigateToCaptionPage = false
                    }
                    dismissAction()
                }) {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(viewModel.selectedQuadrant != nil ? activeColor : inactiveColor)
                .disabled(viewModel.selectedCaptionIndex == nil)
            }
        }
//        NavigationStack {
//        }
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
                                .foregroundColor(.gray)
                            Text("No Photo Selected")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
        }
        .aspectRatio(1.0, contentMode: .fill)
    }
    
    private var captionChoicesContainer: some View {
        VStack(spacing: 16) {
            ForEach(0..<viewModel.availableCaptions.count, id: \.self) { index in
                let captionText = viewModel.availableCaptions[index]
                let isSelected = viewModel.selectedCaptionIndex == index
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedCaptionIndex = index
                    }
                }) {
                    Text(captionText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(isSelected ? .white : .black)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(isSelected ? activeColor : Color(red: 0.95, green: 0.95, blue: 0.97))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedCaptionIndex)
    }
}

// MARK: - Preview Generator
struct CaptionSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let gameViewModel = GameViewModel()
        let productionPostViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
        
        productionPostViewModel.selectedQuadrant = .topLeft
        
        return NavigationView {
            CaptionSelectionView(viewModel: productionPostViewModel)
        }
    }
}
