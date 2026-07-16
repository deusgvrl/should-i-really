//
//  LandingMenuView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 15/07/26.
//
import SwiftUI

struct LandingMenuView: View {
    
    // MARK: - Properties
    var viewModel = GameViewModel()
    @State var showOverwriteAlert: Bool = false
    private let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    
    var body: some View {
        VStack(spacing: 16) {
            // Continue Button (Save Exists)
            if viewModel.gameState != nil {
                Button(action: {
                    viewModel.continueGame()
                }) {
                    Text("Continue")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,16)
                        .background(themeBrown)
                        .clipShape(Capsule())
                }
            }
            // New Game Button
            Button(action: {
                if viewModel.gameState != nil {
                    // Show warning alert if save data exists and will be overwritten
                    showOverwriteAlert = true
                } else {
                    viewModel.startNewGame()
                }
            }) {
                Text("New Game")
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(themeBrown)
                    .clipShape(Capsule())
            }
            
            // Archive Button
            Button(action: {
                viewModel.openArchive()
            }) {
                Text("Archive")
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,16)
                    .background(themeBrown)
                    .clipShape(Capsule())
            }
            
            // Alert Pop-up
        }
        .alert("Are you sure", isPresented: $showOverwriteAlert) {
            Button("No", role: .cancel) {
                
            }
            Button("Yes", role: .destructive) {
                viewModel.deleteActiveSave()
                viewModel.startNewGame()
            }
        } message: {
            Text("Starting a new game will overwrite your current progress")
        }
    }
    
    private var hasCompletedEndings: Bool {
        
        false
    }
}

#Preview {
    LandingMenuView(viewModel: GameViewModel())
}
