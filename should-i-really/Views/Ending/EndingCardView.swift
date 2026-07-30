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

    let lockedFrameColor = Color(
        red: 183 / 255,
        green: 183 / 255,
        blue: 183 / 255
    )  // #B7B7B7
    let lockedInnerColor = Color(
        red: 131 / 255,
        green: 131 / 255,
        blue: 131 / 255
    )  // #838383

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isUnlocked {
                // MARK: - UNLOCKED STATE
                Image(ending?.imageName ?? "placeholder_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.borderBrown, lineWidth: 1.5)
                    )

                Text(ending?.title ?? "Unknown Ending")
                    .font(
                        .system(size: 17, weight: .semibold, design: .rounded)
                    )
                    .foregroundStyle(Color.textBrown)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

            } else {
                // MARK: - LOCKED STATE
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(lockedInnerColor)
                        .frame(width: 150, height: 150)

                    Text("?")
                        .font(
                            .system(size: 80, weight: .bold, design: .rounded)
                        )
                        .foregroundStyle(lockedFrameColor)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.borderBrown, lineWidth: 1.5)
                )

                Text("?")
                    .font(
                        .system(size: 17, weight: .semibold, design: .rounded)
                    )
                    .foregroundStyle(Color.textBrown)
            }
        }
        .frame(width: 150) 
        .frame(maxWidth: .infinity)
        .frame(height: 208)
        .background(isUnlocked ? Color.background : lockedFrameColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.borderBrown, lineWidth: 1.5)
        )
    }
}

#Preview {
    EndingCardView(index: 1, isUnlocked: true, ending: nil)
}
