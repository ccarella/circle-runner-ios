//
//  MenuScene.swift
//  PrincessSavesTheKing
//
//  Created by Chris Carella on 8/4/25.
//

import SpriteKit

@MainActor
class MenuScene: SKScene {
    
    private var playButton: SKShapeNode!
    private var titleLabel: SKLabelNode!
    private var bestScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        // Set accessibility identifier for the scene
        self.accessibilityLabel = "MenuScene"
        self.isAccessibilityElement = true
        
        // Create gradient background
        createGradientBackground()
        setupUI()
    }
    
    private func createGradientBackground() {
        // Use the background image from Art/Environment
        let backgroundTexture = SKTexture(imageNamed: "Background")
        backgroundTexture.filteringMode = .linear // Use linear for background to avoid pixelation
        
        let backgroundNode = SKSpriteNode(texture: backgroundTexture)
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.zPosition = -1
        
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
    
    private func setupUI() {
        // Title - Split into two lines for better visual impact
        let titleLine1 = SKLabelNode(text: "Princess Saves")
        titleLine1.fontName = "Noteworthy-Bold"  // Cozy, handwritten style font
        titleLine1.fontSize = 48
        titleLine1.fontColor = .charcoal
        titleLine1.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
        titleLine1.accessibilityLabel = "Princess Saves"
        titleLine1.isAccessibilityElement = true
        addChild(titleLine1)
        
        let titleLine2 = SKLabelNode(text: "the King")
        titleLine2.fontName = "Noteworthy-Bold"
        titleLine2.fontSize = 48
        titleLine2.fontColor = .charcoal
        titleLine2.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
        titleLine2.accessibilityLabel = "the King"
        titleLine2.isAccessibilityElement = true
        addChild(titleLine2)
        
        // Add a subtle shadow to the title for depth
        let shadowLine1 = SKLabelNode(text: "Princess Saves")
        shadowLine1.fontName = "Noteworthy-Bold"
        shadowLine1.fontSize = 48
        shadowLine1.fontColor = UIColor(white: 0, alpha: 0.15)
        shadowLine1.position = CGPoint(x: size.width / 2 + 2, y: size.height / 2 + 38)
        shadowLine1.zPosition = -0.5
        addChild(shadowLine1)
        
        let shadowLine2 = SKLabelNode(text: "the King")
        shadowLine2.fontName = "Noteworthy-Bold"
        shadowLine2.fontSize = 48
        shadowLine2.fontColor = UIColor(white: 0, alpha: 0.15)
        shadowLine2.position = CGPoint(x: size.width / 2 + 2, y: size.height / 2 - 12)
        shadowLine2.zPosition = -0.5
        addChild(shadowLine2)
        
        // Best Score - positioned lower
        let bestScore = UserDefaults.standard.double(forKey: "bestScore")
        bestScoreLabel = SKLabelNode(text: String(format: "Best: %.1fs", bestScore))
        bestScoreLabel.fontName = "Noteworthy-Light"
        bestScoreLabel.fontSize = 22
        bestScoreLabel.fontColor = .charcoal
        bestScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 80)
        bestScoreLabel.accessibilityLabel = "BestScoreLabel"
        bestScoreLabel.isAccessibilityElement = true
        addChild(bestScoreLabel)
        
        // Play Button - positioned lower
        playButton = SKShapeNode(rectOf: CGSize(width: 200, height: 60), cornerRadius: 30)
        playButton.fillColor = .pastelCoral
        playButton.strokeColor = .pastelCoral
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 140)
        playButton.name = "playButton"
        playButton.accessibilityLabel = "PlayButton"
        playButton.isAccessibilityElement = true
        
        let playLabel = SKLabelNode(text: "Play")
        playLabel.fontName = "Noteworthy-Bold"
        playLabel.fontSize = 32
        playLabel.fontColor = .softWhite
        playLabel.verticalAlignmentMode = .center
        playButton.addChild(playLabel)
        
        addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "playButton" || node.parent?.name == "playButton" {
            startGame()
        }
    }
    
    private func startGame() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameScene, transition: transition)
    }
}

// UserDefaults extension for default values
extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil {
            return defaultValue
        }
        return bool(forKey: key)
    }
}