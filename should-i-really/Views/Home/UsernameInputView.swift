//
//  UsernameInputView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 15/07/26.
//

import SwiftUI

struct UsernameInputView: View {
    @Environment(GameViewModel.self) private var viewModel
    @State private var usernameText: String = ""
    
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
        ZStack {
            // MARK: - Layer Background Asset
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: 150)
                
                // MARK: - Logo Should I Really
                Image("HomeIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 130)
                    .padding(.bottom, 24)
                
                // MARK: - Input Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Create a username")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.borderBrown)
                        .padding(.leading, 4)
                    
                    TextField("johndoe", text: $usernameText)
                        .font(.body)
                        .foregroundStyle(isInvalidInput ? .red : .primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(isInvalidInput ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 7, x: 0, y: 3)
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
                
                Spacer()
                
                // MARK: - Start Button
                Button(action: {
                    viewModel.enterUsername(trimmedUsername)
                }) {
                    Text("Start")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isInputValid ? Color.buttonBrown : Color.unselectedGray)
                        .clipShape(Capsule())
                }
                .disabled(!isInputValid)
                .accessibilityLabel("Start")
                .accessibilityInputLabels(["Start"])
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 28)
        }
    }
}

#Preview {
    UsernameInputView()
        .environment(GameViewModel())
}
