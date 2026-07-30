//
//  TutorialStepCardView.swift
//  should-i-really
//
//  Created by Michael David Sin on 28/07/26.
//

import SwiftUI

struct TutorialStepModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
}

struct TutorialStepCardView: View {
    let step: TutorialStepModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Image Frame Container (296 x 295)
            Image(step.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 296, height: 295)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.borderBrown, lineWidth: 1.5)
                )
            
            // MARK: - Text Description
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.system(size: 20, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.borderBrown)
                
                Text(step.description)
                    .font(.system(size: 17, design: .rounded))
                    .fontWeight(.regular)
                    .foregroundStyle(Color.borderBrown.opacity(0.8))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 2)
        }
        .padding(13)        .frame(width: 322, height: 397, alignment: .topLeading)
        .background(Color(red: 252/255, green: 249/255, blue: 243/255))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.borderBrown, lineWidth: 1.5)
        )
    }
}

#Preview {
    TutorialStepCardView(
        step: TutorialStepModel(
            id: 1,
            title: "1. Add a post",
            description: "Tap the + icon to create a new post.",
            imageName: "tutorial_step1"
        )
    )
    .padding()
    .background(Color.background)
}
