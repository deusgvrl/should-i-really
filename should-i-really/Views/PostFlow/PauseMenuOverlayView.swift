//
//  PauseMenuOverlayView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 27/07/26.
//

import SwiftUI

struct PauseMenuOverlayView: View {
    @Binding var isPresented: Bool
    @Environment(GameViewModel.self) private var gameViewModel
                                      
    @State private var isSoundOn: Bool = true
    @State private var isHapticsOn: Bool = true
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                // MARK: Continue
                VStack(spacing: 12) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPresented = false
                        }
                    } label: {
                        Text("Continue")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color.buttonBrown
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    
                    HStack(spacing: 12) {
                        // MARK: Sound
                        Button {
                            isSoundOn.toggle()
                        } label: {
                            HStack(spacing: 6) {
                                Image(
                                    systemName: isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill"
                                )
                                Text("Sound")
                            }
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.gray.opacity(0.18))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
             
                        // MARK: Haptics
                        Button {
                            isHapticsOn.toggle()
                        } label: {
                            HStack(spacing: 6) {
                                Image(
                                    systemName: isHapticsOn ? "iphone.radiowaves.left.and.right" : "iphone.gen2.slash"
                                )
                                Text("Haptics")
                            }
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.gray.opacity(0.18))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
             
                    // MARK: Tutorial
                    Button {
                        // action
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "book.fill")
                            Text("Tutorial")
                        }
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.buttonBrown)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.buttonBrown, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                                      
                    // MARK: Return to Menu
                    Button {
                        isPresented = false
                        gameViewModel.navigationPath.removeAll()
                    } label: {
                        Text("Return to menu")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
                .frame(width: 300)
                // MARK: Background
                .glassEffect(.regular, in: .containerRelative)
                .clipShape(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                )
                .shadow(color: .black.opacity(0.15), radius: 20)
            }
            .animation(
                .spring(response: 0.1, dampingFraction: 0.2),
                value: isPresented
            )
        }
    }
}
