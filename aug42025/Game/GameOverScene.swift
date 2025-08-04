//
//  GameOverScene.swift
//  CircleRunner
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
        backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        // Game Over label
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontName = "Helvetica-Bold"
        gameOverLabel.fontSize = 42
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        addChild(gameOverLabel)
        
        // Score
        let scoreLabel = SKLabelNode(text: String(format: "%.1fs", score))
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 64
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        addChild(scoreLabel)
        
        // Best score
        let bestScoreLabel = SKLabelNode(text: String(format: "BEST %.1f", bestScore))
        bestScoreLabel.fontName = "Helvetica"
        bestScoreLabel.fontSize = 28
        bestScoreLabel.fontColor = .white
        bestScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        addChild(bestScoreLabel)
        
        // Retry button
        retryButton = SKShapeNode(rectOf: CGSize(width: 180, height: 60), cornerRadius: 30)
        retryButton.fillColor = .white
        retryButton.strokeColor = .white
        retryButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        retryButton.name = "retryButton"
        
        let retryLabel = SKLabelNode(text: "RETRY")
        retryLabel.fontName = "Helvetica-Bold"
        retryLabel.fontSize = 28
        retryLabel.fontColor = .black
        retryLabel.verticalAlignmentMode = .center
        retryButton.addChild(retryLabel)
        
        addChild(retryButton)
        
        // Home button
        homeButton = SKShapeNode(rectOf: CGSize(width: 180, height: 60), cornerRadius: 30)
        homeButton.fillColor = .clear
        homeButton.strokeColor = .white
        homeButton.lineWidth = 3
        homeButton.position = CGPoint(x: frame.midX, y: frame.midY - 180)
        homeButton.name = "homeButton"
        
        let homeLabel = SKLabelNode(text: "HOME")
        homeLabel.fontName = "Helvetica-Bold"
        homeLabel.fontSize = 28
        homeLabel.fontColor = .white
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