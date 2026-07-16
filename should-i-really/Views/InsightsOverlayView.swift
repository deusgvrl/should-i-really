//
//  InsightsOverlayView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//
import SwiftUI

struct InsightsOverlayView: View {
    
    let framingScore: Int
    let captionScore: Int
    
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
                metricCard(title: "Photo Guard", value: framingScore)
                metricCard(title: "Vibe Check", value: captionScore)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Builder untuk Card Metric
    @ViewBuilder
    private func metricCard(title: String, value: Int) -> some View {
        
        let isGood = value == 1
        
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
