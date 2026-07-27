//
//  LandingMenuView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 15/07/26.
//

import SwiftUI

struct LandingMenuView: View {
    
    // MARK: - Properties
    var viewModel: GameViewModel
    @Binding var showOverwriteAlert: Bool
    @State private var showSettingsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: - Conditional Top Buttons
            if viewModel.gameState != nil {
                
                Button(action: {
                    viewModel.continueGame()
                }) {
                    Text("Continue")
                        .font(.system(size: 17, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        showOverwriteAlert = true
                    }
                }) {
                    Text("New Game")
                        .font(.system(size: 17, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.buttonBrown)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            Capsule()
                                .fill(Color.background)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.buttonBrown, lineWidth: 2)
                        )
                }
                .accessibilityLabel("New Game")
                
            } else {
                
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Text("New Game")
                        .font(.system(size: 17, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("New Game")
            }
        }
    }
}

#Preview {
    LandingMenuView(viewModel: GameViewModel(), showOverwriteAlert: .constant(false))
}
