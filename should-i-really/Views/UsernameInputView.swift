//
//  UsernameInputView.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 15/07/26.
//

import SwiftUI

struct UsernameInputView: View {
    var viewModel = GameViewModel()
    @State var usernameText: String = ""
    
    private let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    private let themeDisabledGray = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    private var isInputValid: Bool {
        !usernameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
            
            TextField("Username", text: $usernameText)
                .font(.body)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray6), lineWidth: 1))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
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
    UsernameInputView(viewModel: GameViewModel())
}
