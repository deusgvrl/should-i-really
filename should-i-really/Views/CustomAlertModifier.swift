//
//  CustomAlertModifier.swift
//  should-i-really
//
//  Created by Michael David Sin on 27/07/26.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let cancelTitle: String
    let confirmTitle: String
    let onConfirm: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                // Background Dimmer
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                    // ♿️ Accessibility untuk Background Dimmer
                    .accessibilityLabel("Dismiss alert")
                    .accessibilityHint("Double tap to close the alert")

                // Alert Card Container
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.black)

                    Text(message)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.black)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 12) {
                        // Cancel Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                            AudioController.shared.playSFX(filename: "tap")
                        }) {
                            Text(cancelTitle)
                                .font(.system(size: 18, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.unselectedGray.opacity(0.4))
                                .clipShape(Capsule())
                        }
                        .accessibilityLabel(cancelTitle)
                        .accessibilityInputLabels([cancelTitle])

                        // Confirm Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isPresented = false
                            }
                            AudioController.shared.playSFX(filename: "tap")
                            onConfirm()
                        }) {
                            Text(confirmTitle)
                                .font(.system(size: 18, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.buttonBrown)
                                .clipShape(Capsule())
                        }
                        .accessibilityLabel(confirmTitle)
                        .accessibilityInputLabels([confirmTitle])
                    }
                    .padding(.top, 12)
                }
                .padding(28)
                .background(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .padding(.horizontal, 28)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
                .accessibilityAddTraits(.isModal)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }
}

// MARK: - View Extension
extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        cancelTitle: String = "Cancel",
        confirmTitle: String,
        onConfirm: @escaping () -> Void
    ) -> some View {
        self.modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                cancelTitle: cancelTitle,
                confirmTitle: confirmTitle,
                onConfirm: onConfirm
            )
        )
    }
}
