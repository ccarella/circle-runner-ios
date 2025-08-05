//
//  GameScene.swift
//  PrincessSavesTheKing
//
//  Created by Chris Carella on 8/4/25.
//

import SpriteKit
import GameplayKit

@MainActor
class GameScene: SKScene, SKPhysicsContactDelegate, CastleManagerDelegate {
    
    // Nodes
    private var princess: Princess!
    private var ground: SKNode!
    private var obstacleContainer: SKNode!
    private var hudNode: SKNode!
    private var scoreLabel: SKLabelNode!
    private var bestScoreLabel: SKLabelNode!
    
    // Game state
    private var gameStartTime: TimeInterval = 0
    private var currentScore: TimeInterval = 0
    private var bestScore: TimeInterval = 0
    private var isGameOver = false
    private var currentSpeed: CGFloat = GameConstants.startSpeed
    private var lastMilestone: Int = 0
    private var isGamePaused = false
    
    // Powerup state
    private var isInvincible = false
    private var invincibilityEndTime: TimeInterval = 0
    private var hasSpawnedStar = false
    private var starSpawnTime: TimeInterval = 0
    private var currentStar: Star?
    
    // Castle system
    private var castleManager: CastleManager!
    private var castleApproachIndicator: SKNode?
    private var castleTimeLabel: SKLabelNode!
    private var castleProgressLabel: SKLabelNode!
    
    // Jump mechanics
    private var jumpBufferTime: TimeInterval = 0
    
    // Spawning
    private var lastSpawnTime: TimeInterval = 0
    private var currentSpawnInterval: TimeInterval = GameConstants.initialSpawnInterval
    
    
    override func didMove(to view: SKView) {
        createGradientBackground()
        physicsWorld.gravity = CGVector(dx: 0, dy: CGFloat(GameConstants.gravity))
        physicsWorld.contactDelegate = self
        
        setupGame()
        setupHUD()
        setupCastleManager()
        startGame()
    }
    
    private func createGradientBackground() {
        // Use the background image from Art/Environment
        let backgroundTexture = SKTexture(imageNamed: "Background")
        backgroundTexture.filteringMode = .linear // Use linear for background to avoid pixelation
        
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
        
        // Scale to fill the screen while maintaining aspect ratio
        let textureAspectRatio = backgroundTexture.size().width / backgroundTexture.size().height
        let screenAspectRatio = size.width / size.height
        
        if textureAspectRatio > screenAspectRatio {
            // Texture is wider than screen, fit by height
            backgroundNode.size.height = size.height
            backgroundNode.size.width = size.height * textureAspectRatio
        } else {
            // Texture is taller than screen, fit by width
            backgroundNode.size.width = size.width
            backgroundNode.size.height = size.width / textureAspectRatio
        }
        
        addChild(backgroundNode)
    }
    
    private func setupGame() {
        // Ground
        ground = SKNode()
        ground.position = CGPoint(x: frame.midX, y: GameConstants.groundY)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width * 2, height: 10))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
        addChild(ground)
        
        // Ground visual - removed to keep clean aesthetic
        // let groundLine = SKShapeNode(rect: CGRect(x: -frame.width, y: -2, width: frame.width * 2, height: 4))
        // groundLine.fillColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 0.5) // Semi-transparent green
        // groundLine.strokeColor = .clear
        // ground.addChild(groundLine)
        
        // Create Princess entity
        princess = Princess()
        princess.position = CGPoint(x: frame.width * 0.15, y: GameConstants.groundY)
        princess.updateTrailTarget(self)
        princess.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground | PhysicsCategory.star
        addChild(princess)
        
        // Start in idle state until game begins
        princess.setState(.idle)
        
        // Obstacle container
        obstacleContainer = SKNode()
        addChild(obstacleContainer)
    }
    
    private func setupHUD() {
        hudNode = SKNode()
        addChild(hudNode)
        
        // Current score
        scoreLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = .charcoal
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: frame.height - 60)
        scoreLabel.text = "0.0s"
        hudNode.addChild(scoreLabel)
        
        // Best score
        bestScore = UserDefaults.standard.double(forKey: "bestScore")
        bestScoreLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        bestScoreLabel.fontSize = 22
        bestScoreLabel.fontColor = .charcoal
        bestScoreLabel.horizontalAlignmentMode = .right
        bestScoreLabel.position = CGPoint(x: frame.width - 20, y: frame.height - 60)
        bestScoreLabel.text = String(format: "Best: %.1fs", bestScore)
        hudNode.addChild(bestScoreLabel)
        
        // Castle progress label
        castleProgressLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        castleProgressLabel.fontSize = 20
        castleProgressLabel.fontColor = .charcoal
        castleProgressLabel.horizontalAlignmentMode = .center
        castleProgressLabel.position = CGPoint(x: frame.midX, y: frame.height - 60)
        castleProgressLabel.text = "Castle 1 of 10"
        hudNode.addChild(castleProgressLabel)
        
        // Castle time label (hidden until approaching)
        castleTimeLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        castleTimeLabel.fontSize = 28
        castleTimeLabel.fontColor = .pastelAccentOrange
        castleTimeLabel.horizontalAlignmentMode = .center
        castleTimeLabel.position = CGPoint(x: frame.midX, y: frame.height - 100)
        castleTimeLabel.alpha = 0
        hudNode.addChild(castleTimeLabel)
    }
    
    
    private func startGame() {
        gameStartTime = 0
        currentScore = 0
        isGameOver = false
        currentSpeed = GameConstants.startSpeed
        currentSpawnInterval = GameConstants.initialSpawnInterval
        princess.isGrounded = true
        lastMilestone = 0
        
        // Reset powerup state
        isInvincible = false
        invincibilityEndTime = 0
        hasSpawnedStar = false
        starSpawnTime = TimeInterval.random(in: 10...20)
        currentStar = nil
    }
    
    private func setupCastleManager() {
        castleManager = CastleManager()
        castleManager.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver && !isGamePaused else { return }
        
        let currentTime = CACurrentMediaTime()
        
        // Start the game on first tap if not started
        if gameStartTime == 0 {
            princess.setState(.running)
        }
        
        // Check if we can jump (grounded or within coyote time)
        if princess.isGrounded || (currentTime - princess.lastGroundContactTime) <= GameConstants.coyoteTime {
            princess.jump()
        } else {
            // Store jump in buffer
            jumpBufferTime = currentTime
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver && !isGamePaused else { return }
        
        // Initialize game start time
        if gameStartTime == 0 {
            gameStartTime = currentTime - currentScore // Preserve score when resuming
        }
        
        // Update score
        currentScore = currentTime - gameStartTime
        scoreLabel.text = String(format: "%.1fs", currentScore)
        
        // Check for star spawn
        if !hasSpawnedStar && currentScore >= starSpawnTime {
            spawnStar()
            hasSpawnedStar = true
        }
        
        // Update invincibility
        if isInvincible && currentTime >= invincibilityEndTime {
            endInvincibility()
        }
        
        // Update castle manager
        let frameDelta = 1.0 / 60.0 // Assuming 60 FPS
        castleManager.update(deltaTime: frameDelta)
        
        // Update castle progress display
        castleProgressLabel.text = castleManager.currentCastleDescription
        
        // Check for milestone celebrations (every 10 seconds)
        let currentMilestone = Int(currentScore) / 10
        if currentMilestone > lastMilestone && currentScore > 0 {
            lastMilestone = currentMilestone
            // Brief celebration
            princess.celebrate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                if self?.isGameOver == false {
                    self?.princess.setState(.running)
                }
            }
        }
        
        // Update speed
        let previousSpeed = currentSpeed
        currentSpeed = min(GameConstants.startSpeed + (GameConstants.speedGainPerSecond * CGFloat(currentScore)), GameConstants.maxSpeed)
        
        // Princess animation is now handled by the entity itself
        
        // Update spawn interval
        let spawnProgress = min(currentScore / GameConstants.spawnRampDuration, 1.0)
        currentSpawnInterval = GameConstants.initialSpawnInterval - (GameConstants.initialSpawnInterval - GameConstants.minSpawnInterval) * spawnProgress
        
        // Spawn obstacles
        if currentTime - lastSpawnTime >= currentSpawnInterval {
            spawnObstacle()
            lastSpawnTime = currentTime
        }
        
        // Move obstacles
        let frameDuration = 1.0 / 60.0 // Assuming 60 FPS
        obstacleContainer.enumerateChildNodes(withName: "obstacle") { node, _ in
            node.position.x -= self.currentSpeed * CGFloat(frameDuration)
            
            // Remove off-screen obstacles
            if node.position.x < -100 {
                node.removeFromParent()
            }
        }
        
        // Move star if it exists
        if let star = currentStar {
            star.position.x -= currentSpeed * CGFloat(frameDuration)
            
            // Remove off-screen star
            if star.position.x < -100 {
                star.removeFromParent()
                currentStar = nil
            }
        }
        
        // Check input buffer
        if princess.isGrounded && (currentTime - jumpBufferTime) <= GameConstants.inputBufferTime {
            princess.jump()
            jumpBufferTime = 0
        }
        
        // Keep princess at fixed horizontal position
        // The horizontal jump boost creates the visual effect of forward momentum
        // while the princess actually stays in place (obstacles move towards them)
        if let physicsBody = princess.physicsBody {
            let targetX = frame.width * 0.15
            let currentX = princess.position.x
            if abs(currentX - targetX) > 0.1 {
                princess.position.x = targetX
                physicsBody.velocity.dx = 0
            }
        }
    }
    
    private func spawnStar() {
        let star = Star()
        star.name = "star"
        
        // Position star so princess can jump and reach it
        // Star should appear in the sky but low enough to be reachable
        let jumpHeight = GameConstants.jumpImpulse * 0.8 // Approximate jump height
        star.position = CGPoint(
            x: frame.width + 100,
            y: GameConstants.groundY + jumpHeight
        )
        
        currentStar = star
        addChild(star)
    }
    
    private func spawnObstacle() {
        // Create rock sprite
        let rockTexture = SKTexture(imageNamed: "Rock")
        rockTexture.filteringMode = .linear
        let obstacle = SKSpriteNode(texture: rockTexture)
        obstacle.name = "obstacle"
        
        // Make rocks 20x smaller (scale of 0.05)
        let baseScale: CGFloat = 0.05
        // Add some variety in size
        let scale = baseScale * CGFloat.random(in: 0.8...1.2)
        obstacle.setScale(scale)
        
        // Position the rock 5px lower than ground line
        obstacle.position = CGPoint(
            x: frame.width + 50,
            y: GameConstants.groundY + (obstacle.size.height / 2) - 5
        )
        
        // Create physics body based on rectangle (simpler than texture for small rocks)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        obstacleContainer.addChild(obstacle)
    }
    
    // MARK: - Physics Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.player | PhysicsCategory.ground {
            princess.land()
        } else if collision == PhysicsCategory.player | PhysicsCategory.obstacle {
            if !isInvincible {
                gameOver()
            }
        } else if collision == PhysicsCategory.player | PhysicsCategory.star {
            // Collect star
            if let star = currentStar {
                star.collect()
                currentStar = nil
                startInvincibility()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.player | PhysicsCategory.ground {
            princess.isGrounded = false
        }
    }
    
    private func gameOver() {
        isGameOver = true
        
        // Stop princess animations
        princess.stopRunning()
        
        // Update best score
        if currentScore > bestScore {
            bestScore = currentScore
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.heavyImpact()
        }
        
        // Screen shake
        if !UserDefaults.standard.bool(forKey: "reducedMotion") {
            let shakeAction = createScreenShake()
            scene?.run(shakeAction)
        }
        
        // Transition to game over scene
        let waitAction = SKAction.wait(forDuration: 0.5)
        let transitionAction = SKAction.run {
            let gameOverScene = GameOverScene(size: self.size)
            gameOverScene.score = self.currentScore
            gameOverScene.bestScore = self.bestScore
            gameOverScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.3)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
        run(SKAction.sequence([waitAction, transitionAction]))
    }
    
    private func createScreenShake() -> SKAction {
        let numberOfShakes = 4
        let duration = GameConstants.deathShakeDuration / Double(numberOfShakes)
        let intensity = GameConstants.deathShakeIntensity
        
        var shakeActions: [SKAction] = []
        
        for _ in 0..<numberOfShakes {
            let moveX = CGFloat.random(in: -intensity...intensity)
            let moveY = CGFloat.random(in: -intensity...intensity)
            let shakeAction = SKAction.moveBy(x: moveX, y: moveY, duration: duration / 2)
            let reverseAction = SKAction.moveBy(x: -moveX, y: -moveY, duration: duration / 2)
            shakeActions.append(contentsOf: [shakeAction, reverseAction])
        }
        
        return SKAction.sequence(shakeActions)
    }
    
    // MARK: - Debug
    
    #if DEBUG
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchCount = touches.count
        
        switch touchCount {
        case 2:
            // Slow motion
            physicsWorld.speed = 0.3
            self.speed = 0.3
        // Removed physics debug toggle to prevent red X from appearing
        // case 3:
        //     // Toggle hitboxes
        //     view?.showsPhysics.toggle()
        case 4:
            // Reset best score
            UserDefaults.standard.set(0.0, forKey: "bestScore")
            bestScore = 0
            bestScoreLabel.text = "BEST 0.0"
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 2 {
            // Reset speed
            physicsWorld.speed = 1.0
            self.speed = 1.0
        }
    }
    #endif
    
    // MARK: - Castle Manager Delegate
    
    func castleManager(_ manager: CastleManager, isApproachingCastle castle: Int, timeRemaining: TimeInterval) {
        // Show time remaining
        castleTimeLabel.text = "Castle in \(manager.timeToNextCastleString)"
        
        // Fade in the time label if not visible
        if castleTimeLabel.alpha == 0 {
            castleTimeLabel.run(SKAction.fadeIn(withDuration: 0.5))
            
            // Create approach visual indicator
            createCastleApproachIndicator()
        }
        
        // Pulse the time label
        if timeRemaining < 10 && castleTimeLabel.action(forKey: "pulse") == nil {
            let pulse = SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.3),
                SKAction.scale(to: 1.0, duration: 0.3)
            ])
            castleTimeLabel.run(SKAction.repeatForever(pulse), withKey: "pulse")
        }
    }
    
    func castleManager(_ manager: CastleManager, didReachCastle castle: Int) {
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
        
        // Show appropriate castle scene
        if castle == 10 {
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
    
    func castleManagerDidUpdateProgress(_ manager: CastleManager) {
        // Update any UI elements if needed
        if !manager.isApproachingCastle {
            castleTimeLabel.removeAllActions()
            castleTimeLabel.run(SKAction.fadeOut(withDuration: 0.5))
            castleApproachIndicator?.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
            ]))
            castleApproachIndicator = nil
        }
    }
    
    private func createCastleApproachIndicator() {
        guard castleApproachIndicator == nil else { return }
        
        // Create a subtle vignette effect
        let indicator = SKNode()
        
        // Top gradient
        let topGradient = SKSpriteNode(color: .pastelAccentOrange, size: CGSize(width: frame.width, height: 100))
        topGradient.anchorPoint = CGPoint(x: 0.5, y: 1)
        topGradient.position = CGPoint(x: frame.midX, y: frame.height)
        topGradient.alpha = 0.2
        indicator.addChild(topGradient)
        
        // Add some sparkles
        for _ in 0..<5 {
            let sparkle = SKShapeNode(circleOfRadius: 3)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: frame.height*0.7...frame.height)
            )
            sparkle.alpha = 0
            indicator.addChild(sparkle)
            
            // Animate sparkles
            let fadeIn = SKAction.fadeAlpha(to: 0.8, duration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: CGFloat.random(in: 1...3))
            sparkle.run(SKAction.repeatForever(SKAction.sequence([wait, fadeIn, fadeOut])))
        }
        
        indicator.alpha = 0
        indicator.run(SKAction.fadeIn(withDuration: 1.0))
        
        castleApproachIndicator = indicator
        addChild(indicator)
    }
    
    private func resumeFromCastle() {
        // Resume the game instead of creating a new scene
        isGamePaused = false
        physicsWorld.speed = 1.0
        
        // Clear all obstacles for a fresh start after the castle
        obstacleContainer.removeAllChildren()
        
        // Reset spawn timing for smoother continuation
        lastSpawnTime = 0
        
        // Reset game start time to preserve score continuity
        gameStartTime = 0
        
        // Update castle manager
        castleManager.resumeFromCastleScene()
        
        // Put princess back in running state
        princess.setState(.running)
        
        // Show a brief celebration
        princess.celebrate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if self?.isGameOver == false && self?.isGamePaused == false {
                self?.princess.setState(.running)
            }
        }
    }
    
    private func showEndingScene() {
        // Show ending/credits scene
        let endingScene = EndingScene(size: size)
        endingScene.scaleMode = scaleMode
        endingScene.finalScore = currentScore
        
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(endingScene, transition: transition)
    }
    
    // MARK: - Powerup Functions
    
    private func startInvincibility() {
        isInvincible = true
        invincibilityEndTime = CACurrentMediaTime() + 10.0 // 10 seconds of invincibility
        
        // Start flashing animation on princess
        let fadeOut = SKAction.fadeAlpha(to: 0.4, duration: 0.2)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
        let flash = SKAction.sequence([fadeOut, fadeIn])
        princess.run(SKAction.repeatForever(flash), withKey: "invincibilityFlash")
        
        // Play sound effect if available
        // run(SKAction.playSoundFileNamed("powerup.wav", waitForCompletion: false))
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.heavyImpact()
        }
    }
    
    private func endInvincibility() {
        isInvincible = false
        invincibilityEndTime = 0
        
        // Stop flashing animation
        princess.removeAction(forKey: "invincibilityFlash")
        princess.alpha = 1.0
    }
}