//
//  AudioController.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import Foundation
import AVFoundation
import UIKit

class AudioController {
    static let shared = AudioController()
    
    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    var isSoundOn: Bool {
        get { UserDefaults.standard.object(forKey: "isSoundOn") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "isSoundOn") }
    }
    
    private init() {}
    
    func playBGM(filename: String) {
        let dataAsset = NSDataAsset(name: filename)
        let bundleURL = Bundle.main.url(forResource: filename, withExtension: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if let url = bundleURL {
                bgmPlayer = try AVAudioPlayer(contentsOf: url)
            } else if let asset = dataAsset {
                bgmPlayer = try AVAudioPlayer(data: asset.data)
            }
            
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = isSoundOn ? 0.8 : 0.0
            bgmPlayer?.play()
        } catch {
            print("Failed to play BGM: \(error.localizedDescription)")
        }
    }
    
    func playSFX(filename: String) {
        guard isSoundOn else { return }
        
        let dataAsset = NSDataAsset(name: filename)
        let bundleURL = Bundle.main.url(forResource: filename, withExtension: "wav")
        
        do {
            if let url = bundleURL {
                sfxPlayer = try AVAudioPlayer(contentsOf: url)
            } else if let asset = dataAsset {
                sfxPlayer = try AVAudioPlayer(data: asset.data)
            }
            
            sfxPlayer?.volume = 0.5
            sfxPlayer?.play()
        } catch {
            print("Failed to play SFX: \(error.localizedDescription)")
        }
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        isSoundOn = enabled
        bgmPlayer?.volume = enabled ? 0.8 : 0.0
    }
}
