//
//  Physics.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1       // 1
    static let obstacle: UInt32 = 0b10    // 2
    static let ground: UInt32 = 0b100     // 4
}

struct GameConstants {
    // Physics
    static let gravity: Float = -9.8 * 6.0  // Strong gravity for tight control
    static let jumpImpulse: CGFloat = 200   // Just enough to clear max obstacle (120) with small margin
    static let playerRadius: CGFloat = 16
    static let groundY: CGFloat = 80
    
    // Timing
    static let coyoteTime: TimeInterval = 0.08
    static let inputBufferTime: TimeInterval = 0.1
    
    // Speed
    static let startSpeed: CGFloat = 250
    static let speedGainPerSecond: CGFloat = 1.5
    static let maxSpeed: CGFloat = 600
    
    // Spawning
    static let initialSpawnInterval: TimeInterval = 1.2
    static let minSpawnInterval: TimeInterval = 0.55
    static let spawnRampDuration: TimeInterval = 60.0
    
    // Obstacles
    static let minObstacleHeight: CGFloat = 32
    static let maxObstacleHeight: CGFloat = 120
    static let minObstacleWidth: CGFloat = 24
    static let maxObstacleWidth: CGFloat = 64
    
    // Effects
    static let deathShakeDuration: TimeInterval = 0.15
    static let deathShakeIntensity: CGFloat = 12
}