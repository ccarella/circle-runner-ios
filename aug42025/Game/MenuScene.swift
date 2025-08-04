//
//  MenuScene.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import SpriteKit

@MainActor
class MenuScene: SKScene {
    
    private var playButton: SKShapeNode!
    private var titleLabel: SKLabelNode!
    private var bestScoreLabel: SKLabelNode!
    private var reducedMotionToggle: SKShapeNode!
    private var hapticToggle: SKShapeNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        // Title
        titleLabel = SKLabelNode(text: "CIRCLE RUNNER")
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 150)
        addChild(titleLabel)
        
        // Best Score
        let bestScore = UserDefaults.standard.double(forKey: "bestScore")
        bestScoreLabel = SKLabelNode(text: String(format: "BEST %.1fs", bestScore))
        bestScoreLabel.fontName = "Helvetica"
        bestScoreLabel.fontSize = 24
        bestScoreLabel.fontColor = .white
        bestScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 80)
        addChild(bestScoreLabel)
        
        // Play Button
        playButton = SKShapeNode(rectOf: CGSize(width: 200, height: 60), cornerRadius: 30)
        playButton.fillColor = .white
        playButton.strokeColor = .white
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        playButton.name = "playButton"
        
        let playLabel = SKLabelNode(text: "PLAY")
        playLabel.fontName = "Helvetica-Bold"
        playLabel.fontSize = 28
        playLabel.fontColor = .black
        playLabel.verticalAlignmentMode = .center
        playButton.addChild(playLabel)
        
        addChild(playButton)
        
        // Settings toggles
        setupToggles()
    }
    
    private func setupToggles() {
        // Reduced Motion Toggle
        let reducedMotionLabel = SKLabelNode(text: "Reduced Motion")
        reducedMotionLabel.fontName = "Helvetica"
        reducedMotionLabel.fontSize = 18
        reducedMotionLabel.fontColor = .white
        reducedMotionLabel.position = CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 100)
        reducedMotionLabel.horizontalAlignmentMode = .right
        addChild(reducedMotionLabel)
        
        reducedMotionToggle = createToggle(isOn: UserDefaults.standard.bool(forKey: "reducedMotion"))
        reducedMotionToggle.position = CGPoint(x: size.width / 2 - 40, y: size.height / 2 - 100)
        reducedMotionToggle.name = "reducedMotionToggle"
        addChild(reducedMotionToggle)
        
        // Haptic Toggle
        let hapticLabel = SKLabelNode(text: "Haptics")
        hapticLabel.fontName = "Helvetica"
        hapticLabel.fontSize = 18
        hapticLabel.fontColor = .white
        hapticLabel.position = CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 140)
        hapticLabel.horizontalAlignmentMode = .right
        addChild(hapticLabel)
        
        hapticToggle = createToggle(isOn: UserDefaults.standard.bool(forKey: "hapticsEnabled", defaultValue: true))
        hapticToggle.position = CGPoint(x: size.width / 2 - 40, y: size.height / 2 - 140)
        hapticToggle.name = "hapticToggle"
        addChild(hapticToggle)
    }
    
    private func createToggle(isOn: Bool) -> SKShapeNode {
        let toggle = SKShapeNode(rectOf: CGSize(width: 50, height: 30), cornerRadius: 15)
        toggle.fillColor = isOn ? .green : .gray
        toggle.strokeColor = toggle.fillColor
        
        let knob = SKShapeNode(circleOfRadius: 12)
        knob.fillColor = .white
        knob.strokeColor = .white
        knob.position = CGPoint(x: isOn ? 15 : -15, y: 0)
        knob.name = "knob"
        toggle.addChild(knob)
        
        toggle.userData = ["isOn": isOn]
        
        return toggle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "playButton" || node.parent?.name == "playButton" {
            startGame()
        } else if node.name == "reducedMotionToggle" || node.parent?.name == "reducedMotionToggle" {
            toggleReducedMotion()
        } else if node.name == "hapticToggle" || node.parent?.name == "hapticToggle" {
            toggleHaptics()
        }
    }
    
    private func startGame() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.fade(withDuration: 0.3)
        view?.presentScene(gameScene, transition: transition)
    }
    
    private func toggleReducedMotion() {
        let isOn = !(reducedMotionToggle.userData?["isOn"] as? Bool ?? false)
        reducedMotionToggle.userData?["isOn"] = isOn
        UserDefaults.standard.set(isOn, forKey: "reducedMotion")
        
        // Update toggle appearance
        reducedMotionToggle.fillColor = isOn ? .green : .gray
        reducedMotionToggle.strokeColor = reducedMotionToggle.fillColor
        
        if let knob = reducedMotionToggle.childNode(withName: "knob") {
            knob.run(SKAction.moveTo(x: isOn ? 15 : -15, duration: 0.2))
        }
    }
    
    private func toggleHaptics() {
        let isOn = !(hapticToggle.userData?["isOn"] as? Bool ?? false)
        hapticToggle.userData?["isOn"] = isOn
        UserDefaults.standard.set(isOn, forKey: "hapticsEnabled")
        
        // Update toggle appearance
        hapticToggle.fillColor = isOn ? .green : .gray
        hapticToggle.strokeColor = hapticToggle.fillColor
        
        if let knob = hapticToggle.childNode(withName: "knob") {
            knob.run(SKAction.moveTo(x: isOn ? 15 : -15, duration: 0.2))
        }
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