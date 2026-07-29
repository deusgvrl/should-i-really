//
//  SummaryEndingView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI
import SwiftData

struct EndingSummaryView: View {
    @Environment(GameViewModel.self) private var gameVM
    @Environment(\.modelContext) private var modelContext
    
    @State private var endingVM: EndingViewModel
    @State private var isShowingAlert = false

    @Environment(\.dismiss) private var dismiss
    let endingId: String
    let isArchivePreview: Bool
    
    // MARK: - Color Palette Definitions
    
    private let themeBackground = Color(red: 247/255, green: 244/255, blue: 239/255)
    private let themeText = Color(red: 118/255, green: 84/255, blue: 70/255)
    private let themeButton = Color(red: 172/255, green: 127/255, blue: 94/255)
    
    init(endingId: String, isArchivePreview: Bool = false) {
        self.endingId = endingId
        self.isArchivePreview = isArchivePreview
        _endingVM = State(initialValue: EndingViewModel(endingId: endingId))
    }
    
    var body: some View {
        ZStack {
            themeBackground
                .ignoresSafeArea()
            
            if let ending = endingVM.currentEnding {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Text("Ending")
                            .font(.headline)
                            .foregroundStyle(themeText)
                            .padding(.top, 16)
                        
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
                        
                        VStack(spacing: 8) {
                            Text(ending.title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(themeText)
                                .multilineTextAlignment(.center)
                            
                            Text(ending.mainDescription)
                                .font(.subheadline)
                                .foregroundStyle(themeText)
                                .lineSpacing(4)
                                .multilineTextAlignment(.leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("📷")
                                    Text(ending.photoTraitTitle)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(themeText)
                                }
                                
                                Text(ending.photoTraitDesc)
                                    .font(.subheadline)
                                    .foregroundStyle(themeText)
                                    .lineSpacing(4)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("✍️")
                                    Text(ending.captionTraitTitle)
                                        .font(.subheadline)
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
                        
                        Button {
                            AudioController.shared.playSFX(filename: "tap")
                            if isArchivePreview {
                                dismiss()
                            } else {
                                isShowingAlert = true
                            }
                        } label: {
                            Text(isArchivePreview ? "Back to My Endings" : "Return to Menu")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(themeButton)
                                .clipShape(Capsule())
                        }
                        .padding(.bottom, 24)
                        .accessibilityLabel("Menu")
                        .accessibilityInputLabels(["Menu"])
                        
                    }
                    .padding(.horizontal, 24)
                }
            } else {
                // Fallback
                VStack(spacing: 16) {
                    Text("Ending data not found.")
                        .font(.headline)
                        .foregroundStyle(themeText)
                    
                    Button("Return to Menu") {
                        gameVM.returnToLanding()
                    }
                    .accessibilityLabel("Menu")
                    .accessibilityInputLabels(["Menu"])
                }
            }
        }
        .navigationBarBackButtonHidden(isArchivePreview ? true : false)
        .alert("Congratulations, you graduated!", isPresented: $isShowingAlert) {
            HStack {
                Button("Return to Main Menu", role: .confirm) {
                    gameVM.deleteActiveSave()
                }
                .accessibilityLabel("Return")
                .accessibilityInputLabels(["Return"])
                Button("Stay here", role: .cancel) {
                    
                }
                .accessibilityLabel("Stay")
                .accessibilityInputLabels(["Stay"])
            }
        } message: {
            Text("You won't be able to view your profile feed after leaving this page, but you can always access this summary later in the Endings menu.")
        }
        .onAppear {
            guard !isArchivePreview else { return }
            unlockEnding()
        }
    }
    
    private func unlockEnding() {
        let newUnlocked = UnlockedEndings(endingId: endingId, unlockedAt: Date())
        modelContext.insert(newUnlocked)
        
        do {
            try modelContext.save()
            print("Ending '\(endingId)' Saved")
        } catch {
            print("❌: \(error)")
        }
    }
}

#Preview {
    EndingSummaryView(endingId: "ENDING_6")
        .environment(GameViewModel())
}
