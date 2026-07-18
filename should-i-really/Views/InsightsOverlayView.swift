//
//  InsightsOverlayView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//
import SwiftUI

struct InsightsOverlayView: View {
    
    let framingType : CropType
    let captionType : CropType
    
    // MARK: - Sheet
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Post Insights")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 24)
                .padding(.bottom, 24)
            
            HStack(spacing: 16) {
                metricCard(title: "Photo Guard", type: framingType)
                metricCard(title: "Vibe Check", type: captionType)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Builder untuk Card Metric
    @ViewBuilder
    private func metricCard(title: String, type: CropType) -> some View {
        
        let isGood: Bool = type == .positive
        
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                
                Image(systemName: isGood ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                    .font(.system(size: 78, weight: .semibold))
                    .foregroundColor(isGood ? .green : .red)
                Spacer()
            }
            .padding(.vertical, 45)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
