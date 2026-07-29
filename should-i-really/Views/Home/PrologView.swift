//
//  PrologView.swift
//  should-i-really
//
//  Created by Michael David Sin on 17/07/26.
//

import SwiftUI

struct PrologView: View {
    // Memakai viewModel yang sama untuk mengatur alur navigasi
    @Environment(GameViewModel.self) private var viewModel
    //    var viewModel: GameViewModel
    
    @State private var revealedCharacterCount = [0,0,0]
    @State private var isContinuePromptVisible = false
    
    @State private var isContinuePromptPulsing = false
    
    private let prologueParagraph = ["As a high school student, you'll capture the little moments happening around you everyday life at school.",
                                     "But every photo has more than one side, and every caption shapes how others see it.",
                                     "Choose carefully... your posts will define the reputation you leave behind."
    ]
    
    private let characterTypingDelay: Duration = .milliseconds(25)
    private let paragraphPause: Duration = .milliseconds(700)
    
    
    
    // Warna tema sesuai dengan project kamu
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: - Prologue Paragraphs
                    Spacer()
                    VStack(spacing: 24) {
                        ForEach(prologueParagraph.indices, id: \.self) { index in
                            let paragraph = prologueParagraph[index]
                            let isFinalParagraph = index == prologueParagraph.count - 1
                            
                            ZStack {
                                Text(paragraph)
                                    .font(.body)
                                    .fontWeight(isFinalParagraph ? .medium : .regular)
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .opacity(0)
                                    .accessibilityHidden(true)
                                
                                Text(String(paragraph.prefix(revealedCharacterCount[index])))
                                    .font(.body)
                                    .fontWeight(isFinalParagraph ? .medium : .regular)
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.primary)
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Spacer()
                    
                    if isContinuePromptVisible {
                        Text("Tap to continue")
                            .font(.title)
                            .bold()
                            .foregroundStyle(Color.textBrown)
                            .padding(.top, 8)
                            .opacity(isContinuePromptPulsing ? 0.1 : 1)
                        //                    .scaleEffect(isContinuePromptPulsing ? 1.5 : 1)
                            .animation(
                                .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                                value: isContinuePromptPulsing
                            )
                            .onAppear {
                                isContinuePromptPulsing = true
                            }
                            .transition(.opacity)
                            .accessibilityLabel("Tap to continue")
                            .accessibilityHint("Double tap anywhere on the screen to continue.")
                    }
                    Spacer()
                }
                .frame(minHeight: geo.size.height)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .task {
            for index in prologueParagraph.indices {
                let characterCount = prologueParagraph[index].count
                
                for count in 1...characterCount {
                    guard !Task.isCancelled else { return }
                    
                    revealedCharacterCount[index] = count
                    
                    try? await Task.sleep(for: characterTypingDelay)
                }
                
                if index < prologueParagraph.count - 1 {
                    try? await Task.sleep(for: paragraphPause)
                }
            }
            
            guard !Task.isCancelled else { return }
            withAnimation(.easeIn(duration: 0.6)) {
                isContinuePromptVisible = true
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard isContinuePromptVisible else { return }
            viewModel.continueFromProlog()
            AudioController.shared.playSFX(filename: "tap")
        }
        
    }
    
}

#Preview {
    PrologView()
        .environment(GameViewModel())
}
