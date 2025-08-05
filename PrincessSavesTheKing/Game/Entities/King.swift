//
//  King.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

enum KingAnimationState {
    case idle
    case waving
    case celebration
}

class King: SKNode {
    
    // Properties
    private var bodyNode: SKShapeNode!
    private var headNode: SKShapeNode!
    private var crownNode: SKShapeNode!
    private var leftArm: SKShapeNode!
    private var rightArm: SKShapeNode!
    private var leftEye: SKShapeNode!
    private var rightEye: SKShapeNode!
    private var mouthNode: SKShapeNode!
    private var beardNode: SKShapeNode!
    
    private var currentState: KingAnimationState = .idle
    private var isAnimating = false
    
    // Constants
    private let kingSize = CGSize(width: 100, height: 140)
    private let headRadius: CGFloat = 35
    
    override init() {
        super.init()
        setupKing()
        setState(.idle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupKing() {
        // Create body
        bodyNode = SKShapeNode(rect: CGRect(x: -kingSize.width/2, y: -kingSize.height/2, 
                                           width: kingSize.width, height: kingSize.height * 0.6),
                              cornerRadius: 20)
        bodyNode.fillColor = .pastelRoyalPurple
        bodyNode.strokeColor = .pastelRoyalPurple.darker()
        bodyNode.lineWidth = 3
        bodyNode.position = CGPoint(x: 0, y: -20)
        addChild(bodyNode)
        
        // Add royal pattern to robe
        addRoyalPattern()
        
        // Create head
        headNode = SKShapeNode(circleOfRadius: headRadius)
        headNode.fillColor = .pastelPeach
        headNode.strokeColor = .pastelPeach.darker()
        headNode.lineWidth = 2
        headNode.position = CGPoint(x: 0, y: 30)
        addChild(headNode)
        
        // Create crown
        setupCrown()
        
        // Create face
        setupFace()
        
        // Create arms
        setupArms()
    }
    
    private func addRoyalPattern() {
        // Add some decorative elements to the robe
        let star1 = createStar(radius: 8)
        star1.fillColor = .pastelGold
        star1.position = CGPoint(x: -20, y: -10)
        bodyNode.addChild(star1)
        
        let star2 = createStar(radius: 8)
        star2.fillColor = .pastelGold
        star2.position = CGPoint(x: 20, y: -10)
        bodyNode.addChild(star2)
        
        let star3 = createStar(radius: 10)
        star3.fillColor = .pastelGold
        star3.position = CGPoint(x: 0, y: -30)
        bodyNode.addChild(star3)
    }
    
    private func createStar(radius: CGFloat) -> SKShapeNode {
        let path = CGMutablePath()
        let angleIncrement = CGFloat.pi * 2 / 10
        
        for i in 0..<10 {
            let angle = angleIncrement * CGFloat(i)
            let r = i % 2 == 0 ? radius : radius * 0.5
            let x = cos(angle) * r
            let y = sin(angle) * r
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        let star = SKShapeNode(path: path)
        star.strokeColor = .clear
        return star
    }
    
    private func setupCrown() {
        // Create crown base
        let crownPath = CGMutablePath()
        let crownWidth: CGFloat = 50
        let crownHeight: CGFloat = 30
        
        // Crown base
        crownPath.move(to: CGPoint(x: -crownWidth/2, y: 0))
        crownPath.addLine(to: CGPoint(x: -crownWidth/2, y: crownHeight * 0.6))
        
        // Crown peaks
        crownPath.addLine(to: CGPoint(x: -crownWidth/3, y: crownHeight))
        crownPath.addLine(to: CGPoint(x: -crownWidth/6, y: crownHeight * 0.7))
        crownPath.addLine(to: CGPoint(x: 0, y: crownHeight))
        crownPath.addLine(to: CGPoint(x: crownWidth/6, y: crownHeight * 0.7))
        crownPath.addLine(to: CGPoint(x: crownWidth/3, y: crownHeight))
        
        crownPath.addLine(to: CGPoint(x: crownWidth/2, y: crownHeight * 0.6))
        crownPath.addLine(to: CGPoint(x: crownWidth/2, y: 0))
        crownPath.closeSubpath()
        
        crownNode = SKShapeNode(path: crownPath)
        crownNode.fillColor = .pastelGold
        crownNode.strokeColor = .pastelGold.darker()
        crownNode.lineWidth = 2
        crownNode.position = CGPoint(x: 0, y: headRadius - 5)
        headNode.addChild(crownNode)
        
        // Add jewels to crown
        let jewel1 = SKShapeNode(circleOfRadius: 4)
        jewel1.fillColor = .pastelCoral
        jewel1.strokeColor = .clear
        jewel1.position = CGPoint(x: -crownWidth/3, y: crownHeight - 5)
        crownNode.addChild(jewel1)
        
        let jewel2 = SKShapeNode(circleOfRadius: 5)
        jewel2.fillColor = .pastelEmerald
        jewel2.strokeColor = .clear
        jewel2.position = CGPoint(x: 0, y: crownHeight - 5)
        crownNode.addChild(jewel2)
        
        let jewel3 = SKShapeNode(circleOfRadius: 4)
        jewel3.fillColor = .pastelOcean
        jewel3.strokeColor = .clear
        jewel3.position = CGPoint(x: crownWidth/3, y: crownHeight - 5)
        crownNode.addChild(jewel3)
    }
    
    private func setupFace() {
        // Eyes
        leftEye = SKShapeNode(circleOfRadius: 5)
        leftEye.fillColor = .charcoal
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -12, y: 8)
        headNode.addChild(leftEye)
        
        rightEye = SKShapeNode(circleOfRadius: 5)
        rightEye.fillColor = .charcoal
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 12, y: 8)
        headNode.addChild(rightEye)
        
        // Add eye sparkle for liveliness
        let leftSparkle = SKShapeNode(circleOfRadius: 2)
        leftSparkle.fillColor = .white
        leftSparkle.strokeColor = .clear
        leftSparkle.position = CGPoint(x: 2, y: 2)
        leftEye.addChild(leftSparkle)
        
        let rightSparkle = SKShapeNode(circleOfRadius: 2)
        rightSparkle.fillColor = .white
        rightSparkle.strokeColor = .clear
        rightSparkle.position = CGPoint(x: 2, y: 2)
        rightEye.addChild(rightSparkle)
        
        // Mouth (happy smile)
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -15, y: -5))
        mouthPath.addQuadCurve(to: CGPoint(x: 15, y: -5), control: CGPoint(x: 0, y: -15))
        
        mouthNode = SKShapeNode(path: mouthPath)
        mouthNode.strokeColor = .charcoal
        mouthNode.lineWidth = 2
        mouthNode.lineCap = .round
        headNode.addChild(mouthNode)
        
        // Beard
        setupBeard()
    }
    
    private func setupBeard() {
        let beardPath = CGMutablePath()
        
        // Create fluffy beard shape
        beardPath.move(to: CGPoint(x: -headRadius, y: -10))
        beardPath.addQuadCurve(to: CGPoint(x: -headRadius * 0.8, y: -headRadius),
                              control: CGPoint(x: -headRadius * 0.9, y: -headRadius * 0.5))
        beardPath.addQuadCurve(to: CGPoint(x: 0, y: -headRadius * 1.2),
                              control: CGPoint(x: -headRadius * 0.4, y: -headRadius * 1.1))
        beardPath.addQuadCurve(to: CGPoint(x: headRadius * 0.8, y: -headRadius),
                              control: CGPoint(x: headRadius * 0.4, y: -headRadius * 1.1))
        beardPath.addQuadCurve(to: CGPoint(x: headRadius, y: -10),
                              control: CGPoint(x: headRadius * 0.9, y: -headRadius * 0.5))
        
        beardNode = SKShapeNode(path: beardPath)
        beardNode.fillColor = UIColor(white: 0.95, alpha: 1.0)
        beardNode.strokeColor = UIColor(white: 0.9, alpha: 1.0)
        beardNode.lineWidth = 2
        headNode.addChild(beardNode)
        
        // Move beard behind the mouth
        beardNode.zPosition = -1
    }
    
    private func setupArms() {
        // Left arm
        leftArm = SKShapeNode(rect: CGRect(x: -5, y: -20, width: 10, height: 40), cornerRadius: 5)
        leftArm.fillColor = .pastelPeach
        leftArm.strokeColor = .pastelPeach.darker()
        leftArm.lineWidth = 2
        leftArm.position = CGPoint(x: -kingSize.width/2 - 5, y: 0)
        // Note: SKShapeNode doesn't have anchorPoint, will use position for rotation pivot
        bodyNode.addChild(leftArm)
        
        // Right arm
        rightArm = SKShapeNode(rect: CGRect(x: -5, y: -20, width: 10, height: 40), cornerRadius: 5)
        rightArm.fillColor = .pastelPeach
        rightArm.strokeColor = .pastelPeach.darker()
        rightArm.lineWidth = 2
        rightArm.position = CGPoint(x: kingSize.width/2 + 5, y: 0)
        // Note: SKShapeNode doesn't have anchorPoint, will use position for rotation pivot
        bodyNode.addChild(rightArm)
    }
    
    // MARK: - Animation States
    
    func setState(_ state: KingAnimationState) {
        guard currentState != state else { return }
        
        stopAllAnimations()
        currentState = state
        
        switch state {
        case .idle:
            startIdleAnimation()
        case .waving:
            startWavingAnimation()
        case .celebration:
            startCelebrationAnimation()
        }
    }
    
    private func stopAllAnimations() {
        isAnimating = false
        removeAllActions()
        bodyNode.removeAllActions()
        headNode.removeAllActions()
        leftArm.removeAllActions()
        rightArm.removeAllActions()
        leftEye.removeAllActions()
        rightEye.removeAllActions()
    }
    
    private func startIdleAnimation() {
        isAnimating = true
        
        // Gentle breathing animation
        let breathe = SKAction.sequence([
            SKAction.scale(to: 1.02, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        bodyNode.run(SKAction.repeatForever(breathe))
        
        // Occasional blink
        startBlinking()
        
        // Slight arm movement
        let armSway = SKAction.sequence([
            SKAction.rotate(toAngle: 0.1, duration: 3.0),
            SKAction.rotate(toAngle: -0.1, duration: 3.0)
        ])
        leftArm.run(SKAction.repeatForever(armSway))
        rightArm.run(SKAction.repeatForever(armSway))
    }
    
    private func startWavingAnimation() {
        isAnimating = true
        
        // Wave the right arm
        let wave = SKAction.sequence([
            SKAction.rotate(toAngle: -1.2, duration: 0.3),
            SKAction.rotate(toAngle: -0.8, duration: 0.2),
            SKAction.rotate(toAngle: -1.2, duration: 0.2),
            SKAction.rotate(toAngle: -0.8, duration: 0.2),
            SKAction.rotate(toAngle: -1.2, duration: 0.2),
            SKAction.rotate(toAngle: 0, duration: 0.3)
        ])
        
        rightArm.run(SKAction.repeatForever(SKAction.sequence([
            wave,
            SKAction.wait(forDuration: 1.0)
        ])))
        
        // Happy expression
        startBlinking()
        
        // Bounce slightly
        let bounce = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 10, duration: 0.5),
            SKAction.moveBy(x: 0, y: -10, duration: 0.5)
        ])
        run(SKAction.repeatForever(bounce))
    }
    
    private func startCelebrationAnimation() {
        isAnimating = true
        
        // Both arms up in celebration
        leftArm.run(SKAction.rotate(toAngle: -2.0, duration: 0.3))
        rightArm.run(SKAction.rotate(toAngle: 2.0, duration: 0.3))
        
        // Jumping celebration
        let jump = SKAction.sequence([
            SKAction.group([
                SKAction.moveBy(x: 0, y: 50, duration: 0.4),
                SKAction.scale(to: 1.1, duration: 0.4)
            ]),
            SKAction.group([
                SKAction.moveBy(x: 0, y: -50, duration: 0.4),
                SKAction.scale(to: 1.0, duration: 0.4)
            ])
        ])
        
        run(SKAction.repeatForever(SKAction.sequence([
            jump,
            SKAction.wait(forDuration: 0.5)
        ])))
        
        // Crown sparkle effect
        addCrownSparkles()
        
        // Extra happy blinking
        startHappyBlinking()
    }
    
    private func startBlinking() {
        let blink = SKAction.sequence([
            SKAction.wait(forDuration: Double.random(in: 2...4)),
            SKAction.run { [weak self] in
                self?.leftEye.yScale = 0.1
                self?.rightEye.yScale = 0.1
            },
            SKAction.wait(forDuration: 0.15),
            SKAction.run { [weak self] in
                self?.leftEye.yScale = 1.0
                self?.rightEye.yScale = 1.0
            }
        ])
        run(SKAction.repeatForever(blink))
    }
    
    private func startHappyBlinking() {
        let happyBlink = SKAction.sequence([
            SKAction.wait(forDuration: Double.random(in: 1...2)),
            SKAction.run { [weak self] in
                self?.leftEye.yScale = 0.3
                self?.rightEye.yScale = 0.3
            },
            SKAction.wait(forDuration: 0.3),
            SKAction.run { [weak self] in
                self?.leftEye.yScale = 1.0
                self?.rightEye.yScale = 1.0
            }
        ])
        run(SKAction.repeatForever(happyBlink))
    }
    
    private func addCrownSparkles() {
        // Create sparkle particles around the crown
        for _ in 0..<3 {
            let sparkle = SKShapeNode(circleOfRadius: 2)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.alpha = 0
            
            let xOffset = CGFloat.random(in: -25...25)
            let yOffset = CGFloat.random(in: 20...40)
            sparkle.position = CGPoint(x: xOffset, y: headRadius + yOffset)
            headNode.addChild(sparkle)
            
            // Animate sparkle
            let sparkleAnimation = SKAction.sequence([
                SKAction.fadeIn(withDuration: 0.3),
                SKAction.group([
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.scale(to: 2.0, duration: 0.5),
                    SKAction.moveBy(x: 0, y: 20, duration: 0.5)
                ]),
                SKAction.removeFromParent()
            ])
            
            sparkle.run(SKAction.sequence([
                SKAction.wait(forDuration: Double.random(in: 0...1)),
                sparkleAnimation
            ]))
        }
        
        // Repeat sparkles
        let repeatSparkles = SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.run { [weak self] in
                self?.addCrownSparkles()
            }
        ])
        
        if currentState == .celebration {
            run(repeatSparkles)
        }
    }
    
    // MARK: - Special Animations
    
    func performReunionAnimation() {
        // Special animation for when Princess and King reunite
        setState(.celebration)
        
        // Add extra effects
        let hearts = SKNode()
        addChild(hearts)
        
        for i in 0..<5 {
            let heart = createHeart(size: 20)
            heart.fillColor = .pastelCoral
            heart.strokeColor = .clear
            heart.position = CGPoint(x: CGFloat.random(in: -50...50), y: 0)
            heart.alpha = 0
            hearts.addChild(heart)
            
            let delay = Double(i) * 0.2
            heart.run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.group([
                    SKAction.fadeIn(withDuration: 0.3),
                    SKAction.moveBy(x: 0, y: 100, duration: 2.0),
                    SKAction.sequence([
                        SKAction.wait(forDuration: 1.0),
                        SKAction.fadeOut(withDuration: 1.0)
                    ])
                ]),
                SKAction.removeFromParent()
            ]))
        }
        
        // Clean up hearts node after animation
        hearts.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.removeFromParent()
        ]))
    }
    
    private func createHeart(size: CGFloat) -> SKShapeNode {
        let path = CGMutablePath()
        let halfSize = size / 2
        
        path.move(to: CGPoint(x: 0, y: -halfSize))
        path.addCurve(to: CGPoint(x: -halfSize, y: halfSize * 0.3),
                     control1: CGPoint(x: -halfSize * 0.5, y: -halfSize * 0.5),
                     control2: CGPoint(x: -halfSize, y: 0))
        path.addArc(center: CGPoint(x: -halfSize * 0.5, y: halfSize * 0.6),
                   radius: halfSize * 0.5,
                   startAngle: .pi,
                   endAngle: 0,
                   clockwise: true)
        path.addArc(center: CGPoint(x: halfSize * 0.5, y: halfSize * 0.6),
                   radius: halfSize * 0.5,
                   startAngle: .pi,
                   endAngle: 0,
                   clockwise: true)
        path.addCurve(to: CGPoint(x: 0, y: -halfSize),
                     control1: CGPoint(x: halfSize, y: 0),
                     control2: CGPoint(x: halfSize * 0.5, y: -halfSize * 0.5))
        path.closeSubpath()
        
        return SKShapeNode(path: path)
    }
}

// MARK: - King Color Extensions

extension UIColor {
    static let pastelRoyalPurple = UIColor(red: 0.6, green: 0.5, blue: 0.8, alpha: 1.0)
}