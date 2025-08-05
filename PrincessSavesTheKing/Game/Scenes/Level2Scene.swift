//
//  Level2Scene.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class Level2Scene: GameScene {
    
    override init(size: CGSize) {
        print("DEBUG: Level2Scene init called with size: \(size)")
        super.init(size: size)
        print("DEBUG: Level2Scene super.init completed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("DEBUG: Level2Scene init(coder:) called")
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        print("DEBUG: Level2Scene didMove called")
        // Set level-specific parameters
        currentLevel = 2
        
        // Call parent implementation
        super.didMove(to: view)
        print("DEBUG: Level2Scene super.didMove completed")
        
        // Show level 2 announcement
        print("DEBUG: About to show level announcement")
        showLevelAnnouncement()
        print("DEBUG: Level announcement shown")
    }
    
    private func showLevelAnnouncement() {
        // Create level announcement
        let levelLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        levelLabel.fontSize = 48
        levelLabel.fontColor = .charcoal
        levelLabel.text = "Level 2"
        levelLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        levelLabel.alpha = 0
        levelLabel.zPosition = 100
        addChild(levelLabel)
        
        let subtitleLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        subtitleLabel.fontSize = 24
        subtitleLabel.fontColor = .charcoal.withAlphaComponent(0.7)
        subtitleLabel.text = "Only 5 castles to the King!"
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        subtitleLabel.alpha = 0
        subtitleLabel.zPosition = 100
        addChild(subtitleLabel)
        
        // Animate the announcement
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        
        levelLabel.run(sequence)
        subtitleLabel.run(sequence)
    }
    
    override func setupCastleManager() {
        // Create castle manager with fewer castles for level 2
        castleManager = CastleManager()
        castleManager.delegate = self
        
        // Configure for level 2 - only 5 castles instead of 10
        castleManager.setLevelParameters(totalCastles: 5, castleInterval: 20.0)
    }
    
    // Handle when player reaches the final castle in Level 2
    override func castleManager(_ manager: CastleManager, didReachCastle castle: Int) {
        // Pause the game
        isGamePaused = true
        physicsWorld.speed = 0
        
        // Hide approach indicators
        castleTimeLabel.removeAllActions()
        castleTimeLabel.run(SKAction.fadeOut(withDuration: 0.3))
        castleApproachIndicator?.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
        castleApproachIndicator = nil
        
        if castle >= 5 {
            // Show final castle scene with King rescue
            let finalCastleScene = FinalCastleScene(size: size)
            finalCastleScene.scaleMode = scaleMode
            finalCastleScene.onContinue = { [weak self] in
                // Go to ending scene
                self?.showEndingScene()
            }
            
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(finalCastleScene, transition: transition)
        } else {
            // Show regular castle scene
            let castleScene = CastleScene(size: size)
            castleScene.castleNumber = castle
            castleScene.scaleMode = scaleMode
            castleScene.onContinue = { [weak self] in
                guard let self = self else { return }
                // Return to this game scene
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(self, transition: transition)
                // Resume game after transition completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.resumeFromCastle()
                }
            }
            
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(castleScene, transition: transition)
        }
    }
}