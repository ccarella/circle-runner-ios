//
//  Haptics.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    private init() {
        lightImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
    }
    
    func lightImpact() {
        guard UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) else { return }
        lightImpactGenerator.impactOccurred()
        lightImpactGenerator.prepare() // Prepare for next use
    }
    
    func heavyImpact() {
        guard UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) else { return }
        heavyImpactGenerator.impactOccurred()
        heavyImpactGenerator.prepare() // Prepare for next use
    }
}