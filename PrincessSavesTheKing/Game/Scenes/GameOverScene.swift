//
//  GameOverScene.swift
//  PrincessSavesTheKing
//
//  Created by Chris Carella on 8/4/25.
//

import SpriteKit

@MainActor
class GameOverScene: SKScene {
    
    var score: TimeInterval = 0
    var bestScore: TimeInterval = 0
    
    private var retryButton: SKShapeNode!
    private var homeButton: SKShapeNode!
    
    override func didMove(to view: SKView) {
        // Set accessibility identifier for the scene
        self.accessibilityLabel = "GameOverScene"
        self.isAccessibilityElement = true
        
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
        // Game Over label with shadow
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Noteworthy-Bold"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .charcoal
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        gameOverLabel.accessibilityLabel = "Game Over"
        gameOverLabel.isAccessibilityElement = true
        addChild(gameOverLabel)
        
        // Shadow for game over label
        let gameOverShadow = SKLabelNode(text: "Game Over")
        gameOverShadow.fontName = "Noteworthy-Bold"
        gameOverShadow.fontSize = 48
        gameOverShadow.fontColor = UIColor(white: 0, alpha: 0.15)
        gameOverShadow.position = CGPoint(x: frame.midX + 2, y: frame.midY + 98)
        gameOverShadow.zPosition = -0.5
        addChild(gameOverShadow)
        
        // Score
        let scoreLabel = SKLabelNode(text: String(format: "%.1fs", score))
        scoreLabel.fontName = "Noteworthy-Bold"
        scoreLabel.fontSize = 56
        scoreLabel.fontColor = .charcoal
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scoreLabel.accessibilityLabel = "FinalScoreLabel"
        scoreLabel.isAccessibilityElement = true
        addChild(scoreLabel)
        
        // Best score
        let bestScoreLabel = SKLabelNode(text: String(format: "Best: %.1fs", bestScore))
        bestScoreLabel.fontName = "Noteworthy-Light"
        bestScoreLabel.fontSize = 24
        bestScoreLabel.fontColor = .charcoal
        bestScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        bestScoreLabel.accessibilityLabel = "BestScoreLabel"
        bestScoreLabel.isAccessibilityElement = true
        addChild(bestScoreLabel)
        
        // Retry button - positioned to the left
        retryButton = SKShapeNode(rectOf: CGSize(width: 160, height: 60), cornerRadius: 30)
        retryButton.fillColor = .pastelCoral
        retryButton.strokeColor = .pastelCoral
        retryButton.position = CGPoint(x: frame.midX - 90, y: frame.midY - 120)
        retryButton.name = "retryButton"
        retryButton.accessibilityLabel = "RetryButton"
        retryButton.isAccessibilityElement = true
        
        let retryLabel = SKLabelNode(text: "Retry")
        retryLabel.fontName = "Noteworthy-Bold"
        retryLabel.fontSize = 26
        retryLabel.fontColor = .softWhite
        retryLabel.verticalAlignmentMode = .center
        retryButton.addChild(retryLabel)
        
        addChild(retryButton)
        
        // Home button - positioned to the right
        homeButton = SKShapeNode(rectOf: CGSize(width: 160, height: 60), cornerRadius: 30)
        homeButton.fillColor = .clear
        homeButton.strokeColor = .pastelLilac
        homeButton.lineWidth = 3
        homeButton.position = CGPoint(x: frame.midX + 90, y: frame.midY - 120)
        homeButton.name = "homeButton"
        homeButton.accessibilityLabel = "MenuButton"
        homeButton.isAccessibilityElement = true
        
        let homeLabel = SKLabelNode(text: "Home")
        homeLabel.fontName = "Noteworthy-Bold"
        homeLabel.fontSize = 26
        homeLabel.fontColor = .pastelLilac
        homeLabel.verticalAlignmentMode = .center
        homeButton.addChild(homeLabel)
        
        addChild(homeButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "retryButton" || node.parent?.name == "retryButton" {
            retry()
        } else if node.name == "homeButton" || node.parent?.name == "homeButton" {
            goHome()
        }
    }
    
    private func retry() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func goHome() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(menuScene, transition: transition)
    }
}