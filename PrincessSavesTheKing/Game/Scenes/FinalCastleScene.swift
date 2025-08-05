//
//  FinalCastleScene.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class FinalCastleScene: SKScene {
    
    // Nodes
    private var backgroundNode: SKSpriteNode!
    private var castleLabel: SKLabelNode!
    private var frog: Frog!
    private var king: King!
    private var princess: Princess!
    private var continueButton: SKShapeNode!
    private var continueLabel: SKLabelNode!
    
    // State
    private var phase: RescuePhase = .frogGreeting
    private var isTransitioning = false
    
    // Callbacks
    var onContinue: (() -> Void)?
    
    enum RescuePhase {
        case frogGreeting
        case kingReveal
        case reunion
        case celebration
    }
    
    override func didMove(to view: SKView) {
        createBackground()
        createCastleDisplay()
        createFrogCharacter()
        
        // Start with frog greeting
        startFrogGreeting()
    }
    
    private func createBackground() {
        // Create a majestic gradient background
        let gradientNode = SKShapeNode(rect: frame)
        gradientNode.fillColor = .pastelGold.withAlphaComponent(0.3)
        gradientNode.strokeColor = .clear
        gradientNode.zPosition = -10
        addChild(gradientNode)
        
        // Add grand castle silhouette
        let castleShape = createGrandCastle()
        castleShape.fillColor = .charcoal.withAlphaComponent(0.3)
        castleShape.strokeColor = .clear
        castleShape.zPosition = -5
        addChild(castleShape)
        
        // Add sparkles for magical effect
        createMagicalSparkles()
    }
    
    private func createGrandCastle() -> SKShapeNode {
        let path = CGMutablePath()
        
        let castleWidth: CGFloat = 300
        let castleHeight: CGFloat = 350
        let centerX = frame.midX
        let baseY = frame.height * 0.2
        
        // Main castle body
        path.addRect(CGRect(x: centerX - castleWidth/2, y: baseY, width: castleWidth, height: castleHeight * 0.5))
        
        // Three grand towers
        let towerWidth = castleWidth * 0.25
        let towerHeight = castleHeight * 0.6
        
        // Left tower
        path.addRect(CGRect(x: centerX - castleWidth/2 - towerWidth/3, y: baseY + castleHeight * 0.5, 
                          width: towerWidth, height: towerHeight))
        // Center tower (tallest)
        path.addRect(CGRect(x: centerX - towerWidth/2, y: baseY + castleHeight * 0.5, 
                          width: towerWidth, height: towerHeight * 1.3))
        // Right tower
        path.addRect(CGRect(x: centerX + castleWidth/2 - towerWidth*2/3, y: baseY + castleHeight * 0.5, 
                          width: towerWidth, height: towerHeight))
        
        // Add flags on towers
        for xPos in [centerX - castleWidth/2, centerX, centerX + castleWidth/2] {
            let flagPole = CGRect(x: xPos - 2, y: baseY + castleHeight, width: 4, height: 40)
            path.addRect(flagPole)
        }
        
        return SKShapeNode(path: path)
    }
    
    private func createMagicalSparkles() {
        for _ in 0..<20 {
            let sparkle = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...4))
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: frame.height*0.6...frame.height)
            )
            sparkle.alpha = 0
            addChild(sparkle)
            
            // Animate sparkles
            let fadeIn = SKAction.fadeAlpha(to: CGFloat.random(in: 0.4...0.8), duration: Double.random(in: 1...2))
            let fadeOut = SKAction.fadeOut(withDuration: Double.random(in: 1...2))
            let wait = SKAction.wait(forDuration: Double.random(in: 0...3))
            sparkle.run(SKAction.repeatForever(SKAction.sequence([wait, fadeIn, fadeOut])))
        }
    }
    
    private func createCastleDisplay() {
        // Castle number label
        castleLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        castleLabel.fontSize = 56
        castleLabel.fontColor = .pastelGold
        castleLabel.text = "The Final Castle"
        castleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.85)
        addChild(castleLabel)
        
        // Add glow effect to title
        let glowLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        glowLabel.fontSize = 56
        glowLabel.fontColor = .white
        glowLabel.text = "The Final Castle"
        glowLabel.position = castleLabel.position
        glowLabel.zPosition = castleLabel.zPosition - 1
        glowLabel.alpha = 0.5
        glowLabel.setScale(1.1)
        addChild(glowLabel)
        
        // Subtitle
        let subtitleLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        subtitleLabel.fontSize = 28
        subtitleLabel.fontColor = .charcoal
        subtitleLabel.text = "Your journey's end awaits..."
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.76)
        addChild(subtitleLabel)
    }
    
    private func createFrogCharacter() {
        // Create the special guard frog
        frog = FrogFactory.shared.createFrog(forCastle: 10)
        frog.position = CGPoint(x: frame.midX - 150, y: frame.height * 0.35)
        frog.alpha = 0
        addChild(frog)
    }
    
    // MARK: - Rescue Sequence Phases
    
    private func startFrogGreeting() {
        // Fade in frog
        frog.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 0.5),
            SKAction.run { [weak self] in
                self?.frog.performGreeting()
                self?.frog.showDialogue { [weak self] in
                    self?.transitionToKingReveal()
                }
            }
        ]))
    }
    
    private func transitionToKingReveal() {
        guard !isTransitioning else { return }
        isTransitioning = true
        phase = .kingReveal
        
        // Move frog aside
        frog.run(SKAction.sequence([
            SKAction.group([
                SKAction.moveBy(x: -100, y: 0, duration: 0.5),
                SKAction.fadeOut(withDuration: 0.5)
            ]),
            SKAction.removeFromParent()
        ]))
        
        // Create and reveal the King
        createKing()
        
        king.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeIn(withDuration: 1.0),
            SKAction.wait(forDuration: 0.5),
            SKAction.run { [weak self] in
                self?.king.setState(.waving)
                self?.showKingDialogue()
            }
        ]))
    }
    
    private func createKing() {
        king = King()
        king.position = CGPoint(x: frame.midX, y: frame.height * 0.4)
        king.alpha = 0
        addChild(king)
    }
    
    private func showKingDialogue() {
        // Create speech bubble for King
        let bubbleWidth: CGFloat = 320
        let bubbleHeight: CGFloat = 120
        
        let speechBubble = SKShapeNode(rect: CGRect(x: -bubbleWidth/2, y: -bubbleHeight/2, 
                                                   width: bubbleWidth, height: bubbleHeight), 
                                      cornerRadius: 20)
        speechBubble.fillColor = .white
        speechBubble.strokeColor = .pastelGold
        speechBubble.lineWidth = 3
        speechBubble.position = CGPoint(x: frame.midX, y: frame.height * 0.65)
        speechBubble.alpha = 0
        addChild(speechBubble)
        
        // King's dialogue
        let dialogueLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        dialogueLabel.fontSize = 20
        dialogueLabel.fontColor = .charcoal
        dialogueLabel.text = "My brave daughter! You found me!"
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = bubbleWidth - 40
        dialogueLabel.verticalAlignmentMode = .center
        dialogueLabel.position = CGPoint(x: 0, y: 10)
        speechBubble.addChild(dialogueLabel)
        
        let dialogueLabel2 = SKLabelNode(fontNamed: "Noteworthy-Light")
        dialogueLabel2.fontSize = 18
        dialogueLabel2.fontColor = .charcoal
        dialogueLabel2.text = "I knew you would come!"
        dialogueLabel2.position = CGPoint(x: 0, y: -15)
        speechBubble.addChild(dialogueLabel2)
        
        // Animate speech bubble
        speechBubble.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 3.0),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent(),
            SKAction.run { [weak self] in
                self?.transitionToReunion()
            }
        ]))
    }
    
    private func transitionToReunion() {
        phase = .reunion
        
        // Create Princess entering from left
        createPrincess()
        
        // Princess runs to King
        princess.setState(.running)
        princess.run(SKAction.sequence([
            SKAction.moveTo(x: frame.midX - 60, duration: 1.5),
            SKAction.run { [weak self] in
                self?.princess.setState(.idle)
                self?.startReunionAnimation()
            }
        ]))
    }
    
    private func createPrincess() {
        princess = Princess()
        princess.position = CGPoint(x: -100, y: frame.height * 0.4)
        princess.setScale(1.2) // Make slightly bigger for the cutscene
        addChild(princess)
    }
    
    private func startReunionAnimation() {
        // Both characters celebrate
        king.performReunionAnimation()
        
        // Add emotional dialogue
        let reunionBubble = createReunionDialogue()
        addChild(reunionBubble)
        
        reunionBubble.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 3.0),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent(),
            SKAction.run { [weak self] in
                self?.transitionToCelebration()
            }
        ]))
    }
    
    private func createReunionDialogue() -> SKNode {
        let container = SKNode()
        container.position = CGPoint(x: frame.midX, y: frame.height * 0.7)
        container.alpha = 0
        
        // Create heart-shaped speech bubble
        let bubble = SKShapeNode(rect: CGRect(x: -200, y: -40, width: 400, height: 80), cornerRadius: 40)
        bubble.fillColor = .pastelCoral.withAlphaComponent(0.9)
        bubble.strokeColor = .pastelCoral
        bubble.lineWidth = 3
        container.addChild(bubble)
        
        let text = SKLabelNode(fontNamed: "Noteworthy-Bold")
        text.fontSize = 24
        text.fontColor = .white
        text.text = "Together at last!"
        text.verticalAlignmentMode = .center
        container.addChild(text)
        
        // Add floating hearts
        for i in 0..<5 {
            let heart = createHeart(size: 20)
            heart.fillColor = .white.withAlphaComponent(0.8)
            heart.position = CGPoint(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -20...20))
            container.addChild(heart)
            
            heart.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.2),
                SKAction.group([
                    SKAction.moveBy(x: 0, y: 50, duration: 2.0),
                    SKAction.fadeOut(withDuration: 2.0)
                ])
            ]))
        }
        
        return container
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
    
    private func transitionToCelebration() {
        phase = .celebration
        
        // Create celebration effects
        createFireworks()
        
        // Create continue button
        createContinueButton()
        
        // Update labels
        castleLabel.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run { [weak self] in
                self?.castleLabel.text = "Victory!"
                self?.castleLabel.fontSize = 72
            },
            SKAction.fadeIn(withDuration: 0.5)
        ]))
    }
    
    private func createFireworks() {
        // Create multiple firework bursts
        for _ in 0..<5 {
            let delay = Double.random(in: 0...2)
            let position = CGPoint(
                x: CGFloat.random(in: frame.width*0.2...frame.width*0.8),
                y: CGFloat.random(in: frame.height*0.6...frame.height*0.8)
            )
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.run { [weak self] in
                    self?.createFireworkBurst(at: position)
                }
            ]))
        }
        
        // Repeat fireworks
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run { [weak self] in
                guard self?.phase == .celebration else { return }
                self?.createFireworks()
            }
        ])))
    }
    
    private func createFireworkBurst(at position: CGPoint) {
        let colors: [UIColor] = [.pastelCoral, .pastelGold, .pastelOcean, .pastelEmerald, .pastelLilac]
        let burstColor = colors.randomElement()!
        
        // Create burst effect
        for i in 0..<12 {
            let angle = (CGFloat.pi * 2 / 12) * CGFloat(i)
            let particle = SKShapeNode(circleOfRadius: 4)
            particle.fillColor = burstColor
            particle.strokeColor = .clear
            particle.position = position
            particle.zPosition = 10
            addChild(particle)
            
            let distance = CGFloat.random(in: 50...100)
            let endPoint = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            particle.run(SKAction.sequence([
                SKAction.group([
                    SKAction.move(to: endPoint, duration: 0.8),
                    SKAction.fadeOut(withDuration: 0.8),
                    SKAction.scale(to: 0.5, duration: 0.8)
                ]),
                SKAction.removeFromParent()
            ]))
        }
        
        // Add sound effect placeholder
        // TODO: Add firework sound when audio is implemented
    }
    
    private func createContinueButton() {
        // Continue button
        let buttonWidth: CGFloat = 250
        let buttonHeight: CGFloat = 70
        continueButton = SKShapeNode(rect: CGRect(x: -buttonWidth/2, y: -buttonHeight/2, 
                                                 width: buttonWidth, height: buttonHeight), 
                                   cornerRadius: 35)
        continueButton.fillColor = .pastelGold
        continueButton.strokeColor = .pastelGold.darker()
        continueButton.lineWidth = 4
        continueButton.position = CGPoint(x: frame.midX, y: frame.height * 0.15)
        continueButton.name = "continueButton"
        continueButton.alpha = 0
        addChild(continueButton)
        
        // Button label
        continueLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        continueLabel.fontSize = 32
        continueLabel.fontColor = .white
        continueLabel.text = "Continue"
        continueLabel.verticalAlignmentMode = .center
        continueButton.addChild(continueLabel)
        
        // Fade in and add bounce animation
        continueButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.run { [weak self] in
                self?.animateContinueButton()
            }
        ]))
    }
    
    private func animateContinueButton() {
        let scale = SKAction.sequence([
            SKAction.scale(to: 1.08, duration: 0.8),
            SKAction.scale(to: 1.0, duration: 0.8)
        ])
        continueButton.run(SKAction.repeatForever(scale))
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        if phase == .celebration && nodesAtPoint.contains(where: { $0.name == "continueButton" || $0 == continueButton }) {
            // Haptic feedback
            if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
                HapticManager.shared.lightImpact()
            }
            
            // Animate button press
            continueButton.run(SKAction.sequence([
                SKAction.scale(to: 0.9, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
            
            // Fade out and continue
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.run { [weak self] in
                    self?.onContinue?()
                }
            ]))
        }
    }
}