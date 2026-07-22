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
        VStack(spacing: 24) {
            
            // MARK: Header Title
            Text("Post Insights")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(.textBrown)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            // MARK: Metric Cards
            HStack(spacing: 16) {
                metricCard(title: "Framing", type: framingType)
                metricCard(title: "Caption", type: captionType)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
    }
    
    // MARK: - Metric Card Builder
    @ViewBuilder
    private func metricCard(title: String, type: CropType) -> some View {
        let isGood: Bool = (type == .positive)
        
        VStack(spacing: 30) {
            Text(title)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.textBrown)
            
            Image(isGood ? "arrow_up" : "arrow_down")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 120)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
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
            captionType: .positive
        )
    }
}
