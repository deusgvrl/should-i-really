//
//  CaptionSelectionView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct CaptionSelectionView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = PostCreationViewModel()
    @Environment(\.dismiss) private var dismissAction
    
    // MARK: - Design System Constants
    private let activeColor = Color(red: 173/255, green: 127/255, blue: 94/255) // Brown
    private let inactiveColor = Color(red: 182/255, green: 182/255, blue: 182/255) // Grey
    
    
    // MARK: - Body
    var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    selectedImageArea
                    captionChoicesContainer
                    
                    Spacer()
                }
                .background(Color.white.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                
                // toolbar
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
                            viewModel.proceedToNextStep()
                        }) {
                            Image(systemName: "arrow.up")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(8.5)
                                .background(viewModel.isCaptionSelected ? activeColor : inactiveColor)
                                .clipShape(Circle())
                        }
                        .disabled(!viewModel.isCaptionSelected)
                    }
                }
            }
        }
    
    private var selectedImageArea: some View {
        ZStack {
            // Placeholder
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 0.95, green: 0.95, blue: 0.97))
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Photo Placeholder")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
        }
        .aspectRatio(1.0, contentMode: .fit)
        .padding(.top, 40)
    }
    
    private var captionChoicesContainer: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.captionChoices) { caption in
                Button(action: {
                    viewModel.selectCaption(caption)
                }) {
                    Text(caption.text)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(viewModel.isCurrentSelection(caption) ? activeColor : inactiveColor)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedCaption)
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview
struct CaptionSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CaptionSelectionView()
    }
}
