//
//  EndingCardView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 16/07/26.
//

import SwiftUI

struct EndingCardView: View {
    // MARK: - Properties
    let index: Int
    let isUnlocked: Bool
    let ending: EndingNode?
    let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    
    var body: some View {
        VStack(spacing: 8) {
            // Unlocked View
            if isUnlocked {
                // Ending Card
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.65, green: 0.49, blue: 0.32).opacity(0.15))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(red: 0.65, green: 0.49, blue: 0.32), lineWidth: 2)
                        )
                    
                    VStack {
                        if let imageName = ending?.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(themeBrown, lineWidth: 2)
                                )
                        } else {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(themeBrown)
                        }
                    }
                }
                
                Text(ending?.title ?? "Ending \(index)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
            } else {
                // Locked View
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fit)
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.6))
                }
                
                Text("Locked")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    EndingCardView(index: 1, isUnlocked: true, ending: nil)
}
