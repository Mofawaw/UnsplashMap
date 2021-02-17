//
//  UMFeedback.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit
import AudioToolbox

struct UMFeedback {
    
    static private let feedbackSupportLevel = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int
    
    static func rigid() {
        switch feedbackSupportLevel {
        case 2: UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        case 1: AudioServicesPlaySystemSound(SystemSoundID(1520))
        default: break
        }
    }

    
    static func soft() {
        switch feedbackSupportLevel {
        case 2: UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case 1: break
        default: break
        }
    }
}
