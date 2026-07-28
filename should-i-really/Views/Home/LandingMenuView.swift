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
    
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Conditional Top Buttons
            if viewModel.gameState != nil {
                
                // MARK: - Continue Button (Filled Brown)
                Button(action: {
                    viewModel.continueGame()
                }) {
                    Text("Continue")
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("Continue")
                
                // MARK: - New Game Button (Outlined)
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
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color(red: 250/255, green: 246/255, blue: 240/255))
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.buttonBrown, lineWidth: 2)
                        )
                }
                .padding(.horizontal, 20)
                .accessibilityLabel("New Game")
                
            } else {
                
                // MARK: - New Game Button (Filled - When No Save Data)
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Text("New Game")
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("New Game")
            }
            
            // MARK: - Collections Button (Text-Only)
            Button(action: {
                viewModel.openArchive()
            }) {
                Text("My Endings")
                    .font(.system(size: 17, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textBrown)
                    .padding(.vertical, 4)
            }
            .accessibilityLabel("My Endings")
        }
    }
}

#Preview {
    LandingMenuView(viewModel: GameViewModel(), showOverwriteAlert: .constant(false))
}
