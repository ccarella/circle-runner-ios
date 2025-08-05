//
//  Star.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class Star: SKNode {
    
    private var sprite: SKShapeNode!
    private var sparkles: [SKShapeNode] = []
    
    override init() {
        super.init()
        setupSprite()
        setupPhysics()
        startAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSprite() {
        // Create a star shape
        let starPath = createStarPath(radius: 20, points: 5)
        sprite = SKShapeNode(path: starPath)
        sprite.fillColor = .pastelAccentOrange
        sprite.strokeColor = .white
        sprite.lineWidth = 2
        sprite.glowWidth = 5
        addChild(sprite)
        
        // Add smaller sparkles around the star
        for i in 0..<8 {
            let angle = CGFloat(i) * (.pi * 2 / 8)
            let sparkle = SKShapeNode(circleOfRadius: 2)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(
                x: cos(angle) * 30,
                y: sin(angle) * 30
            )
            sparkle.alpha = 0
            addChild(sparkle)
            sparkles.append(sparkle)
        }
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.star
        physicsBody?.contactTestBitMask = PhysicsCategory.player
        physicsBody?.collisionBitMask = 0
    }
    
    private func startAnimations() {
        // Main star pulsing animation
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        sprite.run(SKAction.repeatForever(pulse))
        
        // Rotation animation
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 4.0)
        sprite.run(SKAction.repeatForever(rotate))
        
        // Sparkle animations
        for (index, sparkle) in sparkles.enumerated() {
            let delay = SKAction.wait(forDuration: Double(index) * 0.2)
            let fadeIn = SKAction.fadeAlpha(to: 0.8, duration: 0.3)
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let wait = SKAction.wait(forDuration: 1.0)
            let sequence = SKAction.sequence([delay, fadeIn, fadeOut, wait])
            sparkle.run(SKAction.repeatForever(sequence))
        }
        
        // Glow effect animation
        let glowIn = SKAction.customAction(withDuration: 1.0) { node, elapsedTime in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.glowWidth = 5 + (10 * elapsedTime)
            }
        }
        let glowOut = SKAction.customAction(withDuration: 1.0) { node, elapsedTime in
            if let shapeNode = node as? SKShapeNode {
                shapeNode.glowWidth = 15 - (10 * elapsedTime)
            }
        }
        let glowSequence = SKAction.sequence([glowIn, glowOut])
        sprite.run(SKAction.repeatForever(glowSequence))
    }
    
    private func createStarPath(radius: CGFloat, points: Int) -> CGPath {
        let path = CGMutablePath()
        let angleIncrement = CGFloat.pi * 2 / CGFloat(points)
        let innerRadius = radius * 0.4
        
        for i in 0..<points {
            let angle = CGFloat(i) * angleIncrement - .pi / 2
            let x = cos(angle) * radius
            let y = sin(angle) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            let innerAngle = angle + angleIncrement / 2
            let innerX = cos(innerAngle) * innerRadius
            let innerY = sin(innerAngle) * innerRadius
            path.addLine(to: CGPoint(x: innerX, y: innerY))
        }
        
        path.closeSubpath()
        return path
    }
    
    func collect() {
        // Collection effect
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([SKAction.group([scaleUp, fadeOut]), remove])
        run(sequence)
    }
}