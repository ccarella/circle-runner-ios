//
//  Princess.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//
// TODO: Add proper sprite sheets for each animation state:
// - Idle: Standing/breathing animation
// - Running: Already implemented with 12-frame animation (Girl2Walk)
// - Jumping: Mid-air animation frames
// - Landing: Impact/recovery animation
// - Celebration: Victory dance/cheer animation
//

import SpriteKit

enum PrincessAnimationState {
    case idle
    case running
    case jumping
    case landing
    case celebration
}

class Princess: SKNode {
    
    private var sprite: SKSpriteNode!
    private var currentState: PrincessAnimationState = .idle
    private var animationFrames: [SKTexture] = []
    private var trail: SKEmitterNode?
    
    // Physics properties
    var isGrounded = true
    var lastGroundContactTime: TimeInterval = 0
    
    // Animation timing
    private let idleFrameTime: TimeInterval = 0.08
    private let runningFrameTime: TimeInterval = 0.05
    private let jumpingFrameTime: TimeInterval = 0.08
    private let landingFrameTime: TimeInterval = 0.06
    private let celebrationFrameTime: TimeInterval = 0.06
    
    override init() {
        super.init()
        setupSprite()
        setupPhysics()
        setupTrail()
        setState(.idle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSprite() {
        // Load the Girl2Walk sprite sheet (1 row with 12 frames)
        let sheet = SKTexture(imageNamed: "Girl2Walk")
        sheet.filteringMode = .nearest // Crisp pixel art
        
        // Slice the sprite sheet into 12 frames (12 columns x 1 row)
        let cols = 12
        let rows = 1
        let frameWidth = 1.0 / CGFloat(cols)
        let frameHeight = 1.0 / CGFloat(rows)
        
        // Read frames in order: left to right
        for row in 0..<rows {
            for col in 0..<cols {
                let rect = CGRect(
                    x: CGFloat(col) * frameWidth,
                    y: CGFloat(row) * frameHeight,
                    width: frameWidth,
                    height: frameHeight
                )
                let texture = SKTexture(rect: rect, in: sheet)
                texture.filteringMode = .nearest
                animationFrames.append(texture)
            }
        }
        
        // Initialize the sprite with the first frame
        sprite = SKSpriteNode(texture: animationFrames.first)
        
        // Calculate larger target size maintaining aspect ratio
        let targetHeight = GameConstants.playerRadius * 4.5
        let aspectRatio = animationFrames[0].size().width / animationFrames[0].size().height
        let targetWidth = targetHeight * aspectRatio
        
        // Set size directly
        sprite.size = CGSize(width: targetWidth, height: targetHeight)
        
        // Set anchor point at mid-sole (bottom center)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        addChild(sprite)
    }
    
    private func setupPhysics() {
        // Create physics body on the container (self), not the sprite
        let physicsSize = CGSize(width: GameConstants.playerRadius * 2.4, height: GameConstants.playerRadius * 4.5)
        // Position physics body so its bottom edge aligns with the node's position
        // Since we want the princess to stand on the ground, center should be at height/2
        let physicsCenter = CGPoint(x: 0, y: physicsSize.height / 2)
        physicsBody = SKPhysicsBody(rectangleOf: physicsSize, center: physicsCenter)
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground
        physicsBody?.collisionBitMask = PhysicsCategory.ground
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
    }
    
    private func setupTrail() {
        // Skip trail if reduced motion is enabled
        guard !UserDefaults.standard.bool(forKey: "reducedMotion") else { return }
        
        // Create trail programmatically
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
        trail.targetNode = parent // Will be set when added to scene
        trail.position = .zero
        
        addChild(trail)
        self.trail = trail
    }
    
    func setState(_ newState: PrincessAnimationState) {
        guard newState != currentState else { return }
        
        currentState = newState
        
        // Remove any existing animation
        sprite.removeAction(forKey: "animation")
        
        // Update trail visibility based on state
        trail?.particleBirthRate = (newState == .running) ? 100 : 0
        
        // Start new animation based on state
        switch newState {
        case .idle:
            startIdleAnimation()
        case .running:
            startRunningAnimation()
        case .jumping:
            startJumpingAnimation()
        case .landing:
            startLandingAnimation()
        case .celebration:
            startCelebrationAnimation()
        }
    }
    
    private func startIdleAnimation() {
        // TODO: When we have idle sprites, use them here
        // For now, use a slower version of the run animation
        let animate = SKAction.animate(with: animationFrames,
                                     timePerFrame: idleFrameTime,
                                     resize: false,
                                     restore: true)
        let repeatAnimation = SKAction.repeatForever(animate)
        sprite.run(repeatAnimation, withKey: "animation")
    }
    
    private func startRunningAnimation() {
        let animate = SKAction.animate(with: animationFrames,
                                     timePerFrame: runningFrameTime,
                                     resize: false,
                                     restore: true)
        let repeatAnimation = SKAction.repeatForever(animate)
        sprite.run(repeatAnimation, withKey: "animation")
    }
    
    private func startJumpingAnimation() {
        // TODO: When we have jump sprites, use them here
        // For now, use frames 4-7 of the running animation (mid-stride)
        let jumpFrames = Array(animationFrames[4...7])
        let animate = SKAction.animate(with: jumpFrames,
                                     timePerFrame: jumpingFrameTime,
                                     resize: false,
                                     restore: false)
        sprite.run(animate, withKey: "animation")
    }
    
    private func startLandingAnimation() {
        // TODO: When we have landing sprites, use them here
        // For now, use frames 8-10 of the running animation
        let landingFrames = Array(animationFrames[8...10])
        let animate = SKAction.animate(with: landingFrames,
                                     timePerFrame: landingFrameTime,
                                     resize: false,
                                     restore: false)
        let completion = SKAction.run { [weak self] in
            // After landing, transition back to running or idle
            if self?.isGrounded == true {
                self?.setState(.running)
            }
        }
        let sequence = SKAction.sequence([animate, completion])
        sprite.run(sequence, withKey: "animation")
    }
    
    private func startCelebrationAnimation() {
        // TODO: When we have celebration sprites, use them here
        // For now, create a bouncy animation with the existing frames
        let celebrateFrames = animationFrames.reversed() + animationFrames
        let animate = SKAction.animate(with: celebrateFrames,
                                     timePerFrame: celebrationFrameTime,
                                     resize: false,
                                     restore: true)
        let bounce = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 20, duration: 0.2),
            SKAction.moveBy(x: 0, y: -20, duration: 0.2)
        ])
        let group = SKAction.group([animate, bounce])
        let repeatAnimation = SKAction.repeatForever(group)
        sprite.run(repeatAnimation, withKey: "animation")
    }
    
    func jump() {
        // Reset vertical velocity but preserve some horizontal momentum
        let currentVelocity = physicsBody?.velocity ?? CGVector.zero
        physicsBody?.velocity = CGVector(dx: currentVelocity.dx, dy: 0)
        
        // Apply jump impulse
        physicsBody?.applyImpulse(CGVector(
            dx: GameConstants.jumpHorizontalBoost,
            dy: GameConstants.jumpImpulse
        ))
        
        isGrounded = false
        setState(.jumping)
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.lightImpact()
        }
    }
    
    func land() {
        isGrounded = true
        lastGroundContactTime = CACurrentMediaTime()
        
        // Only show landing animation if we were jumping
        if currentState == .jumping {
            setState(.landing)
        } else {
            setState(.running)
        }
    }
    
    func stopRunning() {
        setState(.idle)
    }
    
    func celebrate() {
        setState(.celebration)
    }
    
    func updateTrailTarget(_ target: SKNode?) {
        trail?.targetNode = target
    }
    
    var currentAnimationState: PrincessAnimationState {
        return currentState
    }
}