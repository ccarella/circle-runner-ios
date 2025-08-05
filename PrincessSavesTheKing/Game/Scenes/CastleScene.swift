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
    private var continueButton: SKShapeNode!
    private var continueLabel: SKLabelNode!
    private var frog: Frog!
    
    override func didMove(to view: SKView) {
        // Set accessibility identifier for the scene
        self.accessibilityLabel = "CastleScene"
        self.isAccessibilityElement = true
        
        createBackground()
        createCastleDisplay()
        createFrogCharacter()
        createContinueButton()
        
        // Fade in animation
        alpha = 0
        run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 0.5),
            SKAction.run { [weak self] in
                self?.frog.performGreeting()
                self?.frog.showDialogue()
            }
        ]))
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
        castleLabel.accessibilityLabel = "Castle Milestone!"
        castleLabel.isAccessibilityElement = true
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
        // Create frog using the Frog entity
        frog = FrogFactory.shared.createFrog(forCastle: castleNumber)
        frog.position = CGPoint(x: frame.midX - 120, y: frame.height * 0.45)
        frog.accessibilityLabel = "FrogCharacter"
        frog.isAccessibilityElement = true
        addChild(frog)
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
        continueButton.accessibilityLabel = "ContinueButton"
        continueButton.isAccessibilityElement = true
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
                    print("DEBUG: CastleScene calling onContinue, castle number: \(self?.castleNumber ?? -1)")
                    if self?.onContinue != nil {
                        print("DEBUG: onContinue is not nil, calling it")
                        self?.onContinue?()
                    } else {
                        print("DEBUG: ERROR - onContinue is nil!")
                    }
                    print("DEBUG: CastleScene onContinue completed")
                }
            ]))
        }
    }
}