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
        VStack(spacing: 24) {
            selectedImageArea
            captionChoicesContainer
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
    }
    
    // MARK: - UI Subviews
    
    private var selectedImageArea: some View {
        VStack {
            if let selected = viewModel.selectedQuadrant {
                GeometryReader { geo in
                    QuadrantImageView(
                        imageName: viewModel.currentImageName,
                        quadrant: selected,
                        size: geo.size.width
                    )
                }
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Photo Placeholder")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var captionChoicesContainer: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(0..<viewModel.availableCaptions.count, id: \.self) { index in
                let captionText = viewModel.availableCaptions[index]
                let isSelected = viewModel.selectedCaptionIndex == index
                
                HStack(spacing: 16) {
                    Text(captionText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? activeColor : inactiveColor.opacity(0.6))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? activeColor : Color.gray.opacity(0.2), lineWidth: 2)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        viewModel.selectedCaptionIndex = index
                    }
                }
                .padding(.horizontal)
            }
        }
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
