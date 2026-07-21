//
//  UsernameInputView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 15/07/26.
//

import SwiftUI

struct UsernameInputView: View {
    @Environment(GameViewModel.self) private var viewModel
    @State var usernameText: String = ""
    
    private let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    private let themeDisabledGray = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    private var trimmedUsername: String {
        usernameText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isInputValid: Bool {
        viewModel.isValidUsername(trimmedUsername)
    }
    
    private var isInvalidInput: Bool {
        !trimmedUsername.isEmpty && !isInputValid
    }
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8){
                Text("Create a username")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Choose how you want to be known in this timeline")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Username", text: $usernameText)
                    .font(.body)
                    .foregroundStyle(isInvalidInput ? .red : .primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(isInvalidInput ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if isInvalidInput {
                    Text("Exceeds 16 characters or contains unsupported symbols.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 12)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isInvalidInput)
            
            Button(action: {
                viewModel.enterUsername(usernameText.trimmingCharacters(in: .whitespacesAndNewlines))
            }) {
                Text("Start")
                    .font(.headline)
                    .foregroundStyle(isInputValid ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isInputValid ? themeBrown : themeDisabledGray)
                    .clipShape(Capsule())
            }
            .disabled(!isInputValid)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    UsernameInputView()
        .environment(GameViewModel())
}
