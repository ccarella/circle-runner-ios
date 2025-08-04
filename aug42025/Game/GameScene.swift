//
//  GameScene.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import SpriteKit
import GameplayKit

@MainActor
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Nodes
    private var player: SKShapeNode!
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
    
    // Jump mechanics
    private var lastGroundContactTime: TimeInterval = 0
    private var jumpBufferTime: TimeInterval = 0
    private var isGrounded = false
    
    // Spawning
    private var lastSpawnTime: TimeInterval = 0
    private var currentSpawnInterval: TimeInterval = GameConstants.initialSpawnInterval
    
    // Effects
    private var playerTrail: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        createGradientBackground()
        physicsWorld.gravity = CGVector(dx: 0, dy: CGFloat(GameConstants.gravity))
        physicsWorld.contactDelegate = self
        
        setupGame()
        setupHUD()
        startGame()
    }
    
    private func createGradientBackground() {
        // Create gradient texture
        let size = CGSize(width: self.size.width, height: self.size.height)
        let topColor = CIColor(color: ColorPalette.skyBlue)
        let bottomColor = CIColor(color: ColorPalette.mint)
        
        let filter = CIFilter(name: "CILinearGradient")!
        filter.setValue(CIVector(x: 0, y: 0), forKey: "inputPoint0")
        filter.setValue(CIVector(x: 0, y: size.height), forKey: "inputPoint1")
        filter.setValue(topColor, forKey: "inputColor0")
        filter.setValue(bottomColor, forKey: "inputColor1")
        
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(filter.outputImage!, from: CGRect(origin: .zero, size: size))!
        
        let texture = SKTexture(cgImage: cgImage)
        let backgroundNode = SKSpriteNode(texture: texture)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -10
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
        
        // Ground visual
        let groundLine = SKShapeNode(rect: CGRect(x: -frame.width, y: -5, width: frame.width * 2, height: 10))
        groundLine.fillColor = .pastelGroundGreen
        groundLine.strokeColor = .clear
        ground.addChild(groundLine)
        
        // Player
        player = SKShapeNode(circleOfRadius: GameConstants.playerRadius)
        player.fillColor = .pastelPlayerPink
        player.strokeColor = .clear
        player.position = CGPoint(x: frame.width * 0.25, y: GameConstants.groundY + GameConstants.playerRadius + 10)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: GameConstants.playerRadius)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground
        player.physicsBody?.collisionBitMask = PhysicsCategory.ground
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0
        
        addChild(player)
        
        // Player trail effect
        if !UserDefaults.standard.bool(forKey: "reducedMotion") {
            if let trail = SKEmitterNode(fileNamed: "PlayerTrail") {
                trail.targetNode = self
                trail.position = .zero
                player.addChild(trail)
                playerTrail = trail
            } else {
                // Create trail programmatically if file doesn't exist
                let trail = SKEmitterNode()
                // Create a small circle texture for particles
                let particle = SKShapeNode(circleOfRadius: 4)
                particle.fillColor = .white
                particle.strokeColor = .clear
                let texture = SKView().texture(from: particle)
                trail.particleTexture = texture
                trail.particleBirthRate = 100
                trail.particleLifetime = 0.5
                trail.particleScale = 0.2
                trail.particleScaleSpeed = -0.4
                trail.particleAlpha = 0.8
                trail.particleAlphaSpeed = -1.6
                trail.particleSpeed = 50
                trail.particleSpeedRange = 20
                trail.emissionAngle = .pi
                trail.particleColor = .pastelPlayerPink
                trail.particleColorBlendFactor = 1.0
                trail.targetNode = self
                player.addChild(trail)
                playerTrail = trail
            }
        }
        
        // Obstacle container
        obstacleContainer = SKNode()
        addChild(obstacleContainer)
    }
    
    private func setupHUD() {
        hudNode = SKNode()
        addChild(hudNode)
        
        // Current score
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = .charcoal
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: frame.height - 60)
        scoreLabel.text = "0.0s"
        hudNode.addChild(scoreLabel)
        
        // Best score
        bestScore = UserDefaults.standard.double(forKey: "bestScore")
        bestScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        bestScoreLabel.fontSize = 24
        bestScoreLabel.fontColor = .charcoal
        bestScoreLabel.horizontalAlignmentMode = .right
        bestScoreLabel.position = CGPoint(x: frame.width - 20, y: frame.height - 60)
        bestScoreLabel.text = String(format: "BEST %.1f", bestScore)
        hudNode.addChild(bestScoreLabel)
    }
    
    private func startGame() {
        gameStartTime = 0
        currentScore = 0
        isGameOver = false
        currentSpeed = GameConstants.startSpeed
        currentSpawnInterval = GameConstants.initialSpawnInterval
        isGrounded = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        
        let currentTime = CACurrentMediaTime()
        
        // Check if we can jump (grounded or within coyote time)
        if isGrounded || (currentTime - lastGroundContactTime) <= GameConstants.coyoteTime {
            jump()
        } else {
            // Store jump in buffer
            jumpBufferTime = currentTime
        }
    }
    
    private func jump() {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: GameConstants.jumpImpulse))
        isGrounded = false
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.lightImpact()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        // Initialize game start time
        if gameStartTime == 0 {
            gameStartTime = currentTime
        }
        
        // Update score
        currentScore = currentTime - gameStartTime
        scoreLabel.text = String(format: "%.1fs", currentScore)
        
        // Update speed
        currentSpeed = min(GameConstants.startSpeed + (GameConstants.speedGainPerSecond * CGFloat(currentScore)), GameConstants.maxSpeed)
        
        // Update spawn interval
        let spawnProgress = min(currentScore / GameConstants.spawnRampDuration, 1.0)
        currentSpawnInterval = GameConstants.initialSpawnInterval - (GameConstants.initialSpawnInterval - GameConstants.minSpawnInterval) * spawnProgress
        
        // Spawn obstacles
        if currentTime - lastSpawnTime >= currentSpawnInterval {
            spawnObstacle()
            lastSpawnTime = currentTime
        }
        
        // Move obstacles
        let deltaTime = 1.0 / 60.0 // Assuming 60 FPS
        obstacleContainer.enumerateChildNodes(withName: "obstacle") { node, _ in
            node.position.x -= self.currentSpeed * CGFloat(deltaTime)
            
            // Remove off-screen obstacles
            if node.position.x < -100 {
                node.removeFromParent()
            }
        }
        
        // Check input buffer
        if isGrounded && (currentTime - jumpBufferTime) <= GameConstants.inputBufferTime {
            jump()
            jumpBufferTime = 0
        }
    }
    
    private func spawnObstacle() {
        let obstacle = SKShapeNode(rectOf: CGSize(
            width: CGFloat.random(in: GameConstants.minObstacleWidth...GameConstants.maxObstacleWidth),
            height: CGFloat.random(in: GameConstants.minObstacleHeight...GameConstants.maxObstacleHeight)
        ))
        obstacle.fillColor = .pastelObstacleBlue
        obstacle.strokeColor = .clear
        obstacle.name = "obstacle"
        
        let obstacleHeight = obstacle.frame.height
        obstacle.position = CGPoint(
            x: frame.width + 50,
            y: GameConstants.groundY + obstacleHeight / 2
        )
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.frame.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        obstacleContainer.addChild(obstacle)
    }
    
    // MARK: - Physics Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.player | PhysicsCategory.ground {
            isGrounded = true
            lastGroundContactTime = CACurrentMediaTime()
        } else if collision == PhysicsCategory.player | PhysicsCategory.obstacle {
            gameOver()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.player | PhysicsCategory.ground {
            isGrounded = false
        }
    }
    
    private func gameOver() {
        isGameOver = true
        
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
}