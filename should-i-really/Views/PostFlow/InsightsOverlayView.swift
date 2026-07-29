//
//  InsightsOverlayView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import SwiftUI

struct InsightsOverlayView: View {

    let framingType: CropType
    let captionType: CropType

    var body: some View {
        VStack(spacing: 23) {

            // MARK: Header Title
            Text("Post Insights")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(.textBrown)
                .padding(.top, 23)

            // MARK: Metric Cards
            HStack(spacing: 16) {
                metricCard(
                    title: "Framing",
                    description:
                        "Framing means selecting what to show and what to hide to shape how people understand a message.",
                    type: framingType
                )
                metricCard(
                    title: "Caption",
                    description:
                        "Captions can change how people interpret a photo by influencing its meaning and emotional impact.",
                    type: captionType
                )
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
    }

    // MARK: - Metric Card Builder
    @ViewBuilder
    private func metricCard(title: String, description: String, type: CropType)
        -> some View
    {
        let isGood: Bool = (type == .positive)

        VStack(spacing: 0) {
            // MARK: Title & Description Group
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.textBrown)

                Text(description)
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.regular)
                    .foregroundStyle(.textBrown)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()

            // MARK: Indicator Image
            Image(isGood ? "arrow_up" : "arrow_down")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 134)
                .offset(y: -32)
        }
        .padding(.top, 24)
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.06))
        .cornerRadius(20)
    }
}

// MARK: - Canvas Preview
#Preview {
    ZStack {
        Color.background.ignoresSafeArea()

        InsightsOverlayView(
            framingType: .positive,
            captionType: .negative
        )
    }
}
