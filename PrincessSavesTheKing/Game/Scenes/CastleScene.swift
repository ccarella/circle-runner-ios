//
//  CastleScene.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class CastleScene: SKScene {
    
    var castleNumber: Int = 1
    var onContinue: (() -> Void)?
    
    private var backgroundNode: SKSpriteNode!
    private var castleLabel: SKLabelNode!
    private var messageLabel: SKLabelNode!
    private var continueButton: SKShapeNode!
    private var continueLabel: SKLabelNode!
    private var frogSprite: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        createBackground()
        createCastleDisplay()
        createFrogCharacter()
        createMessage()
        createContinueButton()
        
        // Fade in animation
        alpha = 0
        run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    private func createBackground() {
        // Create a soft gradient background
        let gradientNode = SKShapeNode(rect: frame)
        gradientNode.fillColor = .pastelSkyBlue
        gradientNode.strokeColor = .clear
        gradientNode.zPosition = -10
        addChild(gradientNode)
        
        // Add castle silhouette (placeholder for now)
        let castleShape = SKShapeNode()
        let path = CGMutablePath()
        
        // Simple castle shape
        let castleWidth: CGFloat = 200
        let castleHeight: CGFloat = 250
        let centerX = frame.midX
        let baseY = frame.height * 0.3
        
        // Castle body
        path.addRect(CGRect(x: centerX - castleWidth/2, y: baseY, width: castleWidth, height: castleHeight * 0.6))
        
        // Towers
        let towerWidth = castleWidth * 0.25
        let towerHeight = castleHeight * 0.4
        path.addRect(CGRect(x: centerX - castleWidth/2 - towerWidth/2, y: baseY + castleHeight * 0.6, width: towerWidth, height: towerHeight))
        path.addRect(CGRect(x: centerX + castleWidth/2 - towerWidth/2, y: baseY + castleHeight * 0.6, width: towerWidth, height: towerHeight))
        path.addRect(CGRect(x: centerX - towerWidth/2, y: baseY + castleHeight * 0.6, width: towerWidth, height: towerHeight * 1.2))
        
        castleShape.path = path
        castleShape.fillColor = .charcoal.withAlphaComponent(0.3)
        castleShape.strokeColor = .clear
        castleShape.zPosition = -5
        addChild(castleShape)
    }
    
    private func createCastleDisplay() {
        // Castle number label
        castleLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        castleLabel.fontSize = 48
        castleLabel.fontColor = .charcoal
        castleLabel.text = "Castle \(castleNumber)"
        castleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.85)
        addChild(castleLabel)
        
        // Add a subtitle
        let subtitleLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        subtitleLabel.fontSize = 24
        subtitleLabel.fontColor = .charcoal.withAlphaComponent(0.7)
        subtitleLabel.text = castleNumber < 10 ? "The journey continues..." : "The final castle!"
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.78)
        addChild(subtitleLabel)
    }
    
    private func createFrogCharacter() {
        // Create a simple frog sprite (placeholder)
        let frogSize = CGSize(width: 80, height: 80)
        let frogShape = SKShapeNode(ellipseOf: frogSize)
        frogShape.fillColor = .pastelEmerald
        frogShape.strokeColor = .pastelEmerald.darker()
        frogShape.lineWidth = 3
        frogShape.position = CGPoint(x: frame.midX - 100, y: frame.height * 0.5)
        addChild(frogShape)
        
        // Add eyes
        let eyeSize: CGFloat = 15
        let leftEye = SKShapeNode(circleOfRadius: eyeSize)
        leftEye.fillColor = .white
        leftEye.strokeColor = .charcoal
        leftEye.position = CGPoint(x: -20, y: 20)
        frogShape.addChild(leftEye)
        
        let rightEye = SKShapeNode(circleOfRadius: eyeSize)
        rightEye.fillColor = .white
        rightEye.strokeColor = .charcoal
        rightEye.position = CGPoint(x: 20, y: 20)
        frogShape.addChild(rightEye)
        
        // Add pupils
        let pupilSize: CGFloat = 8
        let leftPupil = SKShapeNode(circleOfRadius: pupilSize)
        leftPupil.fillColor = .charcoal
        leftPupil.strokeColor = .clear
        leftEye.addChild(leftPupil)
        
        let rightPupil = SKShapeNode(circleOfRadius: pupilSize)
        rightPupil.fillColor = .charcoal
        rightPupil.strokeColor = .clear
        rightEye.addChild(rightPupil)
        
        // Animate frog
        let hop = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 20, duration: 0.3),
            SKAction.moveBy(x: 0, y: -20, duration: 0.3)
        ])
        let wait = SKAction.wait(forDuration: 2.0)
        frogShape.run(SKAction.repeatForever(SKAction.sequence([hop, wait])))
    }
    
    private func createMessage() {
        // Frog's message based on castle number
        let messages = [
            "The King went for a walk... somewhere",
            "He mentioned something about another castle",
            "I think he's playing hide and seek",
            "He left his crown here, so he'll be back",
            "Try the next castle, I'm pretty sure",
            "He was here yesterday... or was it last week?",
            "Almost there! I think...",
            "Next castle for sure! Maybe...",
            "OK, he's definitely in the next one"
        ]
        
        let messageIndex = min(castleNumber - 1, messages.count - 1)
        let message = castleNumber == 10 ? "The King is here! You found him!" : messages[messageIndex]
        
        // Speech bubble background
        let bubbleWidth: CGFloat = 300
        let bubbleHeight: CGFloat = 100
        let bubble = SKShapeNode(rect: CGRect(x: -bubbleWidth/2, y: -bubbleHeight/2, width: bubbleWidth, height: bubbleHeight), cornerRadius: 20)
        bubble.fillColor = .white
        bubble.strokeColor = .charcoal.withAlphaComponent(0.3)
        bubble.lineWidth = 2
        bubble.position = CGPoint(x: frame.midX + 50, y: frame.height * 0.5)
        addChild(bubble)
        
        // Message text
        messageLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        messageLabel.fontSize = 18
        messageLabel.fontColor = .charcoal
        messageLabel.text = message
        messageLabel.numberOfLines = 2
        messageLabel.preferredMaxLayoutWidth = bubbleWidth - 40
        messageLabel.verticalAlignmentMode = .center
        bubble.addChild(messageLabel)
    }
    
    private func createContinueButton() {
        // Continue button
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 60
        continueButton = SKShapeNode(rect: CGRect(x: -buttonWidth/2, y: -buttonHeight/2, width: buttonWidth, height: buttonHeight), cornerRadius: 30)
        continueButton.fillColor = .pastelPlayerPink
        continueButton.strokeColor = .pastelPlayerPink.darker()
        continueButton.lineWidth = 3
        continueButton.position = CGPoint(x: frame.midX, y: frame.height * 0.2)
        continueButton.name = "continueButton"
        addChild(continueButton)
        
        // Button label
        continueLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        continueLabel.fontSize = 28
        continueLabel.fontColor = .white
        continueLabel.text = castleNumber == 10 ? "Celebrate!" : "Continue"
        continueLabel.verticalAlignmentMode = .center
        continueButton.addChild(continueLabel)
        
        // Add bounce animation to button
        let scale = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 0.8),
            SKAction.scale(to: 1.0, duration: 0.8)
        ])
        continueButton.run(SKAction.repeatForever(scale))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        if nodesAtPoint.contains(where: { $0.name == "continueButton" || $0 == continueButton }) {
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
                SKAction.fadeOut(withDuration: 0.3),
                SKAction.run { [weak self] in
                    self?.onContinue?()
                }
            ]))
        }
    }
}