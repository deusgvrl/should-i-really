//
//  TutorialScreenView.swift
//  should-i-really
//
//  Created by Michael David Sin on 28/07/26.
//

import SwiftUI

struct TutorialScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Tutorial Steps Data
    private let steps: [TutorialStepModel] = [
        TutorialStepModel(
            id: 1,
            title: "1. Add a post",
            description: "Tap the + icon to create a new post.",
            imageName: "tutorial_step1"
        ),
        TutorialStepModel(
            id: 2,
            title: "2. Select Photo",
            description: "Choose one photo out of the two available options",
            imageName: "tutorial_step2"
        ),
        TutorialStepModel(
            id: 3,
            title: "3. Select Caption",
            description: "Choose one caption for the picture.",
            imageName: "tutorial_step3"
        ),
        TutorialStepModel(
            id: 4,
            title: "4. Upload your post",
            description: "Tap the ↑ icon to publish your post.",
            imageName: "tutorial_step4"
        )
    ]
    
    var body: some View {
        ZStack {
            // MARK: - Background Layer
            Color.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                // MARK: - Header Title
                VStack(spacing: 4) {
                    Text("How To Play?")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textBrown)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                
                // MARK: - Step Cards List
                VStack(spacing: 20) {
                    ForEach(steps) { step in
                        TutorialStepCardView(step: step)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        // MARK: - Navigation Toolbar (Mengikuti pola ArchiveView)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Tutorial")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textBrown)
            }
        }
    }
}

#Preview {
    NavigationStack {
        TutorialScreenView()
    }
}
