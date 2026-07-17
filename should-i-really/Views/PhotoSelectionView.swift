//
//  PhotoSelectionView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct PhotoSelectionView: View {
    @Environment(PostCreationViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let totalSize = geometry.size.width
                let tileSize = totalSize / 2
                
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(QuadrantPosition.allCases, id: \.self) { quadrant in
                        let isActive = viewModel.activeQuadrants.contains(quadrant)
                        let isSelected = viewModel.selectedQuadrant == quadrant
                        
                        ZStack {
                            QuadrantImageView(
                                imageName: viewModel.currentImageName,
                                quadrant: quadrant,
                                size: tileSize
                            )
                            
                            if !isActive {
                                Color.black.opacity(0.75)
                                    .border(Color.gray, width: 1)
                            }
                            
                            if isActive {
                                Color.white.opacity(0)
                                    .border(Color.gray, width: 1)
                            }
                            
                            if isSelected {
                                Color.clear
                                    .border(Color.brown, width: 4)
                                Image("Crop")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(width: tileSize, height: tileSize)
                        .clipped()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isActive {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    viewModel.selectedQuadrant = quadrant
                                }
                            }
                        }
                    }
                }
                .frame(width: totalSize, height: totalSize)
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationDestination(isPresented: $viewModel.navigateToCaptionScreen) {
            CaptionSelectionView()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Choose Your Photo")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.confirmPhotoSelection()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.body.weight(.medium))
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(viewModel.selectedQuadrant != nil ? .brown : .gray)
                .disabled(viewModel.selectedQuadrant == nil)
            }
        }
    }
}

struct QuadrantImageView: View {
    let imageName: String
    let quadrant: QuadrantPosition
    let size: CGFloat
    
    var body: some View {
        GeometryReader { _ in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size * 2, height: size * 2)
                .offset(
                    x: (quadrant == .topLeft || quadrant == .bottomLeft) ? 0 : -size,
                    y: (quadrant == .topLeft || quadrant == .topRight) ? 0 : -size
                )
        }
        .frame(width: size, height: size)
        .clipped()
    }
}

//struct PhotoSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        let gameViewModel = GameViewModel()
//        let productionPostViewModel = PostCreationViewModel(gameViewModel: gameViewModel)
//        
//        return NavigationStack {
//            PhotoSelectionView()
//        }
//    }
//}

