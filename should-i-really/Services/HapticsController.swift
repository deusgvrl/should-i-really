//
//  HapticsController.swift
//  should-i-really
//
//  Created by Amadeus Gavriel on 13/07/26.
//

import CoreHaptics
import UIKit

class HapticsController {
    static let shared = HapticsController()
    private var engine: CHHapticEngine?
    
    var isHapticsOn: Bool {
        get { UserDefaults.standard.object(forKey: "isHapticsOn") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "isHapticsOn") }
    }

    private init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            engine?.stoppedHandler = { reason in
                print("Haptic Engine Stopped: \(reason)")
            }
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
        } catch {
            print("Failed to create haptic engine: \(error.localizedDescription)")
        }
    }

    func playContinuousHaptic(duration: TimeInterval = 1.0) {
        guard isHapticsOn, CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            try engine?.start()
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

            let continuousEvent = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [intensity, sharpness],
                relativeTime: 0,
                duration: duration
            )

            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play continuous haptic: \(error.localizedDescription)")
        }
    }
    
    func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard isHapticsOn else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
