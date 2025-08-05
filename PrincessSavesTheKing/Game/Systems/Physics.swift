//
//  Physics.swift
//  PrincessSavesTheKing
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
    static let gravity: Float = -9.8 * 3.5  // Slightly reduced gravity for longer jumps
    static let jumpImpulse: CGFloat = 180   // 80% of 225 (reduced by 20%)
    static let jumpHorizontalBoost: CGFloat = 120  // 80% of 150 (reduced by 20%)
    static let playerRadius: CGFloat = 16
    static let groundY: CGFloat = 29    // Lowered by another 15% from 34
    
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
    static let minObstacleHeight: CGFloat = 20
    static let maxObstacleHeight: CGFloat = 30  // Reduced from 120 to match tiny jumps
    static let minObstacleWidth: CGFloat = 24
    static let maxObstacleWidth: CGFloat = 64
    
    // Effects
    static let deathShakeDuration: TimeInterval = 0.15
    static let deathShakeIntensity: CGFloat = 12
}