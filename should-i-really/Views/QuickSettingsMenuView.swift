//
//  QuickSettingsMenuView.swift
//  should-i-really
//
//  Created by Jose Putra Perdana Taneo on 29/07/26.
//

import SwiftUI
                                                                                                                       
struct QuickSettingsMenuView: View {
    @Environment(GameViewModel.self) private var gameViewModel
                                                                                                                       
    @AppStorage("isSoundOn") private var isSoundOn: Bool = true
    @State private var isHapticsOn: Bool = true
    @State private var shouldOpenTutorial: Bool = false
    
    var iconName: String = "ellipsis"
    var iconColor: Color = .textBrown
    var isProminent: Bool = false
                                                                                                                       
    var body: some View {
        Menu {
            ControlGroup {
                // MARK: - Sound Toggle
                Button {
                    isSoundOn.toggle()
                    AudioController.shared.setSoundEnabled(isSoundOn)
                    if isSoundOn {
                        AudioController.shared.playSFX(filename: "tap")
                    }
                } label: {
                    Image(
                        systemName: isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill"
                    )
                    Text("Sound")
                }
    
                // MARK: - Haptics Toggle
                Button {
                    isHapticsOn.toggle()
                } label: {
                    Image(
                        systemName: isHapticsOn ? "iphone.radiowaves.left.and.right" : "iphone.gen2.slash"
                    )
                    Text("Haptics")
                }
            }
                
            Divider()
                
            // MARK: - Tutorial
            Button {
                AudioController.shared.playSFX(filename: "tap")
                shouldOpenTutorial = true
                gameViewModel.openTutorial()
            } label: {
                Image(systemName: "questionmark")
                Text("Tutorial")
            }
        } label: {
            if isProminent {
                Image(systemName: iconName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.buttonBrown)
                    .clipShape(Circle())
            } else {
                Image(systemName: iconName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(iconColor)
            }
        }
        .menuActionDismissBehavior(.disabled)
    }
}
  
#Preview {
    QuickSettingsMenuView(iconName: "ellipsis.circle.fill")
        .environment(GameViewModel())
}
