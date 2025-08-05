//
//  EndingScene.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class EndingScene: SKScene {
    
    // Properties
    var finalScore: TimeInterval = 0
    
    // UI Elements
    private var titleLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var creditsContainer: SKNode!
    private var playAgainButton: SKShapeNode!
    private var playAgainLabel: SKLabelNode!
    private var mainMenuButton: SKShapeNode!
    private var mainMenuLabel: SKLabelNode!
    
    // State
    private var isTransitioning = false
    
    override func didMove(to view: SKView) {
        createBackground()
        createTitleSection()
        createScoreSection()
        createCredits()
        createButtons()
        
        // Save completion
        saveGameCompletion()
        
        // Start animations
        startAnimations()
        
        // Show ending narrative
        showEndingNarrative()
    }
    
    private func createBackground() {
        // Create a beautiful gradient background
        let topColor = UIColor.pastelGold.withAlphaComponent(0.3)
        let bottomColor = UIColor.pastelSkyBlue
        
        let gradientNode = SKShapeNode(rect: frame)
        gradientNode.fillColor = bottomColor
        gradientNode.strokeColor = .clear
        gradientNode.zPosition = -10
        addChild(gradientNode)
        
        // Add golden overlay at top
        let overlay = SKShapeNode(rect: CGRect(x: 0, y: frame.height * 0.6, 
                                              width: frame.width, height: frame.height * 0.4))
        overlay.fillColor = topColor
        overlay.strokeColor = .clear
        overlay.zPosition = -9
        addChild(overlay)
        
        // Add celebration sparkles
        createCelebrationSparkles()
    }
    
    private func createCelebrationSparkles() {
        for _ in 0..<30 {
            let sparkle = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...3))
            sparkle.fillColor = [UIColor.white, UIColor.pastelGold, UIColor.pastelCoral].randomElement()!
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            sparkle.alpha = 0
            sparkle.zPosition = -5
            addChild(sparkle)
            
            // Animate sparkles
            let fadeIn = SKAction.fadeAlpha(to: CGFloat.random(in: 0.3...0.8), duration: Double.random(in: 1...3))
            let fadeOut = SKAction.fadeOut(withDuration: Double.random(in: 1...3))
            let moveUp = SKAction.moveBy(x: 0, y: CGFloat.random(in: 20...50), duration: Double.random(in: 3...5))
            let wait = SKAction.wait(forDuration: Double.random(in: 0...2))
            
            sparkle.run(SKAction.repeatForever(SKAction.sequence([
                wait,
                SKAction.group([fadeIn, moveUp]),
                fadeOut,
                SKAction.moveBy(x: 0, y: -20, duration: 0)
            ])))
        }
    }
    
    private func createTitleSection() {
        // Main title
        titleLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        titleLabel.fontSize = 64
        titleLabel.fontColor = .pastelGold
        titleLabel.text = "Quest Complete!"
        titleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.85)
        titleLabel.alpha = 0
        addChild(titleLabel)
        
        // Add glow effect
        let glowLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        glowLabel.fontSize = 64
        glowLabel.fontColor = .white
        glowLabel.text = "Quest Complete!"
        glowLabel.position = titleLabel.position
        glowLabel.zPosition = titleLabel.zPosition - 1
        glowLabel.alpha = 0
        glowLabel.setScale(1.1)
        addChild(glowLabel)
        
        // Subtitle
        let subtitleLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        subtitleLabel.fontSize = 32
        subtitleLabel.fontColor = .charcoal
        subtitleLabel.text = "The Princess saved the King!"
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.75)
        subtitleLabel.alpha = 0
        addChild(subtitleLabel)
        
        // Animate appearance
        titleLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeIn(withDuration: 1.0)
        ]))
        
        glowLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeAlpha(to: 0.3, duration: 1.0),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.5, duration: 1.5),
                SKAction.fadeAlpha(to: 0.3, duration: 1.5)
            ]))
        ]))
        
        subtitleLabel.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeIn(withDuration: 1.0)
        ]))
    }
    
    private func createScoreSection() {
        // Score container
        let scoreContainer = SKNode()
        scoreContainer.position = CGPoint(x: frame.midX, y: frame.height * 0.62)
        addChild(scoreContainer)
        
        // Journey time label
        let journeyLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        journeyLabel.fontSize = 24
        journeyLabel.fontColor = .charcoal
        journeyLabel.text = "Your journey took:"
        journeyLabel.position = CGPoint(x: 0, y: 20)
        scoreContainer.addChild(journeyLabel)
        
        // Score display
        scoreLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        scoreLabel.fontSize = 48
        scoreLabel.fontColor = .pastelAccentOrange
        scoreLabel.text = formatTime(finalScore)
        scoreLabel.position = CGPoint(x: 0, y: -20)
        scoreContainer.addChild(scoreLabel)
        
        // Check if it's a new record
        let bestScore = UserDefaults.standard.double(forKey: "bestScore")
        if finalScore < bestScore || bestScore == 0 {
            // New record!
            UserDefaults.standard.set(finalScore, forKey: "bestScore")
            
            let recordLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
            recordLabel.fontSize = 28
            recordLabel.fontColor = .pastelCoral
            recordLabel.text = "New Record!"
            recordLabel.position = CGPoint(x: 0, y: -60)
            scoreContainer.addChild(recordLabel)
            
            // Animate record label
            recordLabel.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.5),
                SKAction.scale(to: 1.0, duration: 0.5)
            ])))
        }
        
        // Animate score section
        scoreContainer.alpha = 0
        scoreContainer.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.fadeIn(withDuration: 1.0)
        ]))
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let tenths = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%d:%02d.%d", minutes, seconds, tenths)
    }
    
    private func createCredits() {
        creditsContainer = SKNode()
        creditsContainer.position = CGPoint(x: frame.midX, y: frame.height * 0.35)
        creditsContainer.alpha = 0
        addChild(creditsContainer)
        
        // Credits title
        let creditsTitle = SKLabelNode(fontNamed: "Noteworthy-Bold")
        creditsTitle.fontSize = 32
        creditsTitle.fontColor = .charcoal
        creditsTitle.text = "Credits"
        creditsTitle.position = CGPoint(x: 0, y: 80)
        creditsContainer.addChild(creditsTitle)
        
        // Credit entries
        let credits = [
            ("Game Design", "Your Studio"),
            ("Programming", "Built with Love"),
            ("Art Direction", "Watercolor Dreams"),
            ("Special Thanks", "You, for playing!")
        ]
        
        var yPosition: CGFloat = 40
        for (role, credit) in credits {
            let roleLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
            roleLabel.fontSize = 18
            roleLabel.fontColor = .charcoal.withAlphaComponent(0.7)
            roleLabel.text = role
            roleLabel.horizontalAlignmentMode = .right
            roleLabel.position = CGPoint(x: -10, y: yPosition)
            creditsContainer.addChild(roleLabel)
            
            let creditLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
            creditLabel.fontSize = 18
            creditLabel.fontColor = .charcoal
            creditLabel.text = credit
            creditLabel.horizontalAlignmentMode = .left
            creditLabel.position = CGPoint(x: 10, y: yPosition)
            creditsContainer.addChild(creditLabel)
            
            yPosition -= 25
        }
        
        // Animate credits
        creditsContainer.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.5),
            SKAction.fadeIn(withDuration: 1.0)
        ]))
    }
    
    private func createButtons() {
        // Play Again button (New Game+)
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 60
        
        playAgainButton = SKShapeNode(rect: CGRect(x: -buttonWidth/2, y: -buttonHeight/2, 
                                                  width: buttonWidth, height: buttonHeight), 
                                     cornerRadius: 30)
        playAgainButton.fillColor = .pastelEmerald
        playAgainButton.strokeColor = .pastelEmerald.darker()
        playAgainButton.lineWidth = 3
        playAgainButton.position = CGPoint(x: frame.midX - 110, y: frame.height * 0.12)
        playAgainButton.name = "playAgainButton"
        playAgainButton.alpha = 0
        addChild(playAgainButton)
        
        playAgainLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        playAgainLabel.fontSize = 24
        playAgainLabel.fontColor = .white
        playAgainLabel.text = "New Game+"
        playAgainLabel.verticalAlignmentMode = .center
        playAgainButton.addChild(playAgainLabel)
        
        // Main Menu button
        mainMenuButton = SKShapeNode(rect: CGRect(x: -buttonWidth/2, y: -buttonHeight/2, 
                                                 width: buttonWidth, height: buttonHeight), 
                                   cornerRadius: 30)
        mainMenuButton.fillColor = .pastelOcean
        mainMenuButton.strokeColor = .pastelOcean.darker()
        mainMenuButton.lineWidth = 3
        mainMenuButton.position = CGPoint(x: frame.midX + 110, y: frame.height * 0.12)
        mainMenuButton.name = "mainMenuButton"
        mainMenuButton.alpha = 0
        addChild(mainMenuButton)
        
        mainMenuLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
        mainMenuLabel.fontSize = 24
        mainMenuLabel.fontColor = .white
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.verticalAlignmentMode = .center
        mainMenuButton.addChild(mainMenuLabel)
        
        // Animate buttons
        playAgainButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.5),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.run { [weak self] in
                self?.animateButton(self?.playAgainButton)
            }
        ]))
        
        mainMenuButton.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.7),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.run { [weak self] in
                self?.animateButton(self?.mainMenuButton)
            }
        ]))
    }
    
    private func animateButton(_ button: SKShapeNode?) {
        guard let button = button else { return }
        
        let scale = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 1.0),
            SKAction.scale(to: 1.0, duration: 1.0)
        ])
        button.run(SKAction.repeatForever(scale))
    }
    
    private func startAnimations() {
        // Add floating animation to title
        let float = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 10, duration: 2.0),
            SKAction.moveBy(x: 0, y: -10, duration: 2.0)
        ])
        titleLabel.run(SKAction.repeatForever(float))
        
        // Create periodic fireworks
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { [weak self] in
                self?.createRandomFirework()
            }
        ])))
    }
    
    private func createRandomFirework() {
        let position = CGPoint(
            x: CGFloat.random(in: frame.width*0.2...frame.width*0.8),
            y: CGFloat.random(in: frame.height*0.5...frame.height*0.7)
        )
        
        let colors: [UIColor] = [.pastelCoral, .pastelGold, .pastelEmerald, .pastelLilac]
        let color = colors.randomElement()!
        
        for i in 0..<8 {
            let angle = (CGFloat.pi * 2 / 8) * CGFloat(i)
            let particle = SKShapeNode(circleOfRadius: 3)
            particle.fillColor = color
            particle.strokeColor = .clear
            particle.position = position
            particle.zPosition = 5
            addChild(particle)
            
            let distance = CGFloat.random(in: 30...60)
            let endPoint = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            particle.run(SKAction.sequence([
                SKAction.group([
                    SKAction.move(to: endPoint, duration: 0.6),
                    SKAction.fadeOut(withDuration: 0.6),
                    SKAction.scale(to: 0.3, duration: 0.6)
                ]),
                SKAction.removeFromParent()
            ]))
        }
    }
    
    private func showEndingNarrative() {
        let narratives = StoryManager.shared.getEndingNarrative()
        var delay: TimeInterval = 4.0 // Start after title animations
        
        for narrative in narratives {
            run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.run { [weak self] in
                    self?.showStoryText(narrative)
                }
            ]))
            delay += narrative.duration + 1.0 // Add gap between narratives
        }
    }
    
    private func saveGameCompletion() {
        // Save that the game has been completed
        UserDefaults.standard.set(true, forKey: "hasCompletedGame")
        UserDefaults.standard.set(Date(), forKey: "firstCompletionDate")
        
        // Increment completion count for New Game+
        let completionCount = UserDefaults.standard.integer(forKey: "gameCompletionCount")
        UserDefaults.standard.set(completionCount + 1, forKey: "gameCompletionCount")
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isTransitioning, let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        if nodesAtPoint.contains(where: { $0.name == "playAgainButton" || $0 == playAgainButton }) {
            handlePlayAgain()
        } else if nodesAtPoint.contains(where: { $0.name == "mainMenuButton" || $0 == mainMenuButton }) {
            handleMainMenu()
        }
    }
    
    private func handlePlayAgain() {
        isTransitioning = true
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.lightImpact()
        }
        
        // Animate button
        playAgainButton.run(SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        
        // Reset game with New Game+ benefits
        UserDefaults.standard.set(true, forKey: "isNewGamePlus")
        
        // Transition to game
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run { [weak self] in
                guard let self = self else { return }
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(gameScene, transition: transition)
            }
        ]))
    }
    
    private func handleMainMenu() {
        isTransitioning = true
        
        // Haptic feedback
        if UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true) {
            HapticManager.shared.lightImpact()
        }
        
        // Animate button
        mainMenuButton.run(SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        
        // Transition to menu
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.3),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run { [weak self] in
                guard let self = self else { return }
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(menuScene, transition: transition)
            }
        ]))
    }
}