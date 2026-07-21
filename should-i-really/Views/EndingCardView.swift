//
//  EndingCardview.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 16/07/26.
//

import SwiftUI

struct EndingCardView: View {
    // MARK: - Properties
    let index: Int // Index of the ending
    let isUnlocked: Bool
    
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
                                .stroke((Color(red: 0.65, green: 0.49, blue: 0.32)), lineWidth: 2))
                    
                    VStack {
                        Image(systemName: "graduationcap.fill")
                            .font(.title2)
                            .foregroundStyle(Color(red: 0.65, green: 0.49, blue: 0.32))
                        Text("E\(index)")
                            .font(.caption2)
                            .bold()
                            .foregroundStyle(Color(red: 0.65, green: 0.49, blue: 0.32))
                    }
                }
                
                Text("Ending \(index)")
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
    EndingCardView(index: 0, isUnlocked: true)
}
