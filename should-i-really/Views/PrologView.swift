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
    
    // Warna tema sesuai dengan project kamu
    private let themeBrown = Color(red: 0.65, green: 0.49, blue: 0.32)
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Title (Mengikuti style HomeScreenView)
            VStack() {
                Text("Should I")
                    .font(.system(size: 70, weight: .bold))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineSpacing(-50)
                    .padding(.top, 40)
                Text("Really?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .offset(x: 52, y: -8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 24)
              
                    .offset(y: -8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: 200)
            
            // MARK: - Prologue Paragraphs
            VStack(spacing: 24) {
                Text("As a high school student, you'll capture the little moments happening around you everyday life at school.")
                    .font(.body)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("But every photo has more than one side, and every caption shapes how others see it.")
                    .font(.body)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Choose carefully... your posts will define the reputation you leave behind.")
                    .font(.body)
                    .fontWeight(.medium)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 48)
            
            // MARK: - Action Button
            Button(action: {
                viewModel.continueFromProlog()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(themeBrown)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PrologView()
        .environment(GameViewModel())
}
