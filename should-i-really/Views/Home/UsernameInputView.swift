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

    private var errorMessage: String? {
        guard !trimmedUsername.isEmpty else { return nil }
        return viewModel.usernameErrorMessage(for: trimmedUsername)
    }

    var body: some View {
        ZStack {
            // MARK: - Layer Background Asset
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 10)
                    .frame(maxHeight: 78)

                // MARK: - Logo Should I Really
                Image("HomeIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
                    .padding(.bottom, 24)

                // MARK: - Input Section
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Create a username")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.borderBrown)
                            .padding(.leading, 4)

                        Text("Enter a username to continue")
                            .font(.system(size: 16, design: .rounded))
                            .fontWeight(.regular)
                            .foregroundStyle(.borderBrown)
                            .padding(.leading, 4)
                    }

                    HStack(spacing: 8) {
                        TextField("Ex: john.doe", text: $usernameText)
                            .font(.body)
                            .foregroundStyle(isInvalidInput ? .red : .primary)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .accessibilityInputLabels(["Input"])

                        if !usernameText.isEmpty {
                            Button(action: {
                                usernameText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.unselectedGray)
                                    .font(.system(size: 18))
                            }
                            .accessibilityLabel("Clear text")
                            .accessibilityInputLabels(["Clear text", "Clear"])
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                isInvalidInput ? Color.red : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: 7,
                        x: 0,
                        y: 3
                    )

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 1)
                            .transition(
                                .opacity.combined(with: .move(edge: .top))
                            )
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isInvalidInput)

                Spacer(minLength: 16)

                // MARK: - Start Button
                Button(action: {
                    AudioController.shared.playSFX(filename: "tap")
                    viewModel.enterUsername(trimmedUsername)
                }) {
                    Text("Start")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            isInputValid
                                ? Color.buttonBrown : Color.unselectedGray
                        )
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
