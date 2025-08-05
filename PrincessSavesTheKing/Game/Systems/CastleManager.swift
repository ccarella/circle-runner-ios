//
//  CastleManager.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import Foundation
import SpriteKit

@MainActor
protocol CastleManagerDelegate: AnyObject {
    func castleManager(_ manager: CastleManager, isApproachingCastle castle: Int, timeRemaining: TimeInterval)
    func castleManager(_ manager: CastleManager, didReachCastle castle: Int)
    func castleManagerDidUpdateProgress(_ manager: CastleManager)
}

@MainActor
class CastleManager {
    
    // Default Constants
    static let defaultCastleInterval: TimeInterval = 30.0 // 30 seconds per level
    static let defaultApproachWarningTime: TimeInterval = 10.0 // Start showing approach indicators 10 seconds before
    static let defaultTotalCastles = 10
    
    // Configurable parameters
    private var castleInterval: TimeInterval = defaultCastleInterval
    private var approachWarningTime: TimeInterval = defaultApproachWarningTime
    private var totalCastles: Int = defaultTotalCastles
    
    // Properties
    weak var delegate: CastleManagerDelegate?
    private(set) var currentCastle: Int = 1
    private(set) var castlesReached: Int = 0
    private(set) var totalPlayTime: TimeInterval = 0
    private(set) var currentSessionTime: TimeInterval = 0
    private(set) var timeToNextCastle: TimeInterval = defaultCastleInterval
    private(set) var isApproachingCastle: Bool = false
    private(set) var hasReachedFinalCastle: Bool = false
    
    // Save keys
    private let castlesReachedKey = "castlesReached"
    private let totalPlayTimeKey = "totalPlayTime"
    private let hasReachedFinalCastleKey = "hasReachedFinalCastle"
    
    init() {
        loadProgress()
    }
    
    // Set custom level parameters
    func setLevelParameters(totalCastles: Int, castleInterval: TimeInterval, approachWarningTime: TimeInterval = 10.0) {
        self.totalCastles = totalCastles
        self.castleInterval = castleInterval
        self.approachWarningTime = approachWarningTime
        self.timeToNextCastle = castleInterval
    }
    
    // MARK: - Public Methods
    
    func update(deltaTime: TimeInterval) {
        guard !hasReachedFinalCastle else { return }
        
        currentSessionTime += deltaTime
        totalPlayTime += deltaTime
        
        // Calculate time to next castle
        let timeInCurrentCastleJourney = currentSessionTime.truncatingRemainder(dividingBy: castleInterval)
        timeToNextCastle = castleInterval - timeInCurrentCastleJourney
        
        // Check if we've reached a castle
        let newCastle = Int(currentSessionTime / castleInterval) + 1
        if newCastle > currentCastle && currentCastle <= totalCastles {
            reachCastle(newCastle)
        }
        
        // Check if approaching castle
        let wasApproaching = isApproachingCastle
        isApproachingCastle = timeToNextCastle <= approachWarningTime && currentCastle <= totalCastles
        
        if isApproachingCastle {
            delegate?.castleManager(self, isApproachingCastle: currentCastle, timeRemaining: timeToNextCastle)
        }
        
        // Notify delegate of any changes
        if wasApproaching != isApproachingCastle {
            delegate?.castleManagerDidUpdateProgress(self)
        }
    }
    
    func reset() {
        currentCastle = 1
        castlesReached = 0
        totalPlayTime = 0
        currentSessionTime = 0
        timeToNextCastle = castleInterval
        isApproachingCastle = false
        hasReachedFinalCastle = false
        saveProgress()
    }
    
    func pauseForCastleScene() {
        // This method is called when showing castle scene
        // The timer is effectively paused because update() won't be called
    }
    
    func resumeFromCastleScene() {
        // Resume normal gameplay
        // The timer continues from where it left off
        // Make sure we don't immediately trigger another castle
        if currentCastle <= totalCastles {
            // Adjust session time to be just after the last castle milestone
            currentSessionTime = Double(currentCastle - 1) * castleInterval + 0.1
        }
    }
    
    // MARK: - Private Methods
    
    private func reachCastle(_ castle: Int) {
        currentCastle = castle
        castlesReached = max(castlesReached, castle - 1) // castles reached is 0-indexed
        
        if castle > totalCastles {
            hasReachedFinalCastle = true
        }
        
        saveProgress()
        delegate?.castleManager(self, didReachCastle: min(castle, totalCastles))
    }
    
    private func loadProgress() {
        castlesReached = UserDefaults.standard.integer(forKey: castlesReachedKey)
        totalPlayTime = UserDefaults.standard.double(forKey: totalPlayTimeKey)
        hasReachedFinalCastle = UserDefaults.standard.bool(forKey: hasReachedFinalCastleKey)
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(castlesReached, forKey: castlesReachedKey)
        UserDefaults.standard.set(totalPlayTime, forKey: totalPlayTimeKey)
        UserDefaults.standard.set(hasReachedFinalCastle, forKey: hasReachedFinalCastleKey)
    }
    
    // MARK: - Utility Methods
    
    var progressPercentage: Float {
        return Float(castlesReached) / Float(totalCastles)
    }
    
    var timeToNextCastleString: String {
        let minutes = Int(timeToNextCastle) / 60
        let seconds = Int(timeToNextCastle) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var currentCastleDescription: String {
        if hasReachedFinalCastle {
            return "Journey Complete!"
        } else if currentCastle > totalCastles {
            return "The End"
        } else {
            return "Castle \(currentCastle) of \(totalCastles)"
        }
    }
}