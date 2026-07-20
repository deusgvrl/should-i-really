//
//  SummaryEndingView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct EndingSummaryView: View {
    @Environment(GameViewModel.self) private var gameVM
    @State private var endingVM: EndingViewModel
    
    // MARK: - Color Palette Definitions
    
    private let themeBackground = Color(red: 247/255, green: 244/255, blue: 239/255)
    private let themeText = Color(red: 118/255, green: 84/255, blue: 70/255)
    private let themeButton = Color(red: 172/255, green: 127/255, blue: 94/255)
    
    init(endingId: String) {
        _endingVM = State(initialValue: EndingViewModel(endingId: endingId))
    }
    
    var body: some View {
        ZStack {
            themeBackground
                .ignoresSafeArea()
            
            if let ending = endingVM.currentEnding {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. Header Title
                        Text("Ending")
                            .font(.headline)
                            .foregroundStyle(themeText)
                            .padding(.top, 16)
                        
                        // 2. Dynamic Image
                        Image(ending.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(themeText.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.top, 8)
                        
                        // 3. Archetype Title
                        Text(ending.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(themeText)
                            .multilineTextAlignment(.center)
                        
                        // 4. Main Description
                        Text(ending.mainDescription)
                            .font(.body)
                            .foregroundStyle(themeText)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 8)
                        
                        // 5. Traits Breakdown
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // Photo Trait
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("📷")
                                    Text(ending.photoTraitTitle)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(themeText)
                                }
                                
                                Text(ending.photoTraitDesc)
                                    .font(.subheadline)
                                    .foregroundStyle(themeText)
                                    .lineSpacing(4)
                            }
                            
                            // Caption Trait
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("✍️")
                                    Text(ending.captionTraitTitle)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(themeText)
                                }
                                
                                Text(ending.captionTraitDesc)
                                    .font(.subheadline)
                                    .foregroundStyle(themeText)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer(minLength: 32)
                        
                        // 6. Return Button
                        Button(action: {
                            gameVM.deleteActiveSave()
                        }) {
                            Text("Return to Menu")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(themeButton)
                                .clipShape(Capsule())
                        }
                        .padding(.bottom, 24)
                        
                    }
                    .padding(.horizontal, 24)
                }
            } else {
                // Fallback jika data ID tidak ditemukan di JSON
                VStack(spacing: 16) {
                    Text("Ending data not found.")
                        .font(.headline)
                        .foregroundStyle(themeText)
                    
                    Button("Return to Menu") {
                        gameVM.returnToLanding()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EndingSummaryView(endingId: "ENDING_9")
        .environment(GameViewModel())
}
