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
    @State private var showOverwriteAlert: Bool = false
    @State private var showSettingsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: - Conditional Top Buttons
            if viewModel.gameState != nil {
                
                Button(action: {
                    viewModel.continueGame()
                }) {
                    Text("Continue")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                
                Button(action: {
                    showOverwriteAlert = true
                }) {
                    Text("New Game")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("New Game")
                
            } else {
                
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Text("New Game")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("New Game")
            }
            
            // MARK: - Bottom Row: Archive & Setting (Tersier - Lebih Ringkas)
            HStack(spacing: 10) {

                Button(action: {
                    viewModel.openArchive()
                }) {
                    Text("Archive")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("Archive")

                Button(action: {
                    showSettingsSheet = true
                }) {
                    Text("Setting")
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12) 
                        .background(Color.buttonBrown)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("Setting")
            }
        }

        .alert("Are you sure?", isPresented: $showOverwriteAlert) {
            Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) {
                viewModel.deleteActiveSave()
                viewModel.startNewGame()
            }
        } message: {
            Text("Starting a new game will overwrite your current progress")
        }
    }
}

#Preview {
    LandingMenuView(viewModel: GameViewModel())
}
