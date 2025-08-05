//
//  StoryTextDisplay.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

class StoryTextDisplay: SKNode {
    
    // Properties
    private var backgroundNode: SKShapeNode?
    private var textLabel: SKLabelNode!
    private var shadowLabel: SKLabelNode?
    
    // Configuration
    private let padding: CGFloat = 20
    private let cornerRadius: CGFloat = 15
    private let fadeInDuration: TimeInterval = 0.5
    private let fadeOutDuration: TimeInterval = 0.5
    private let typewriterSpeed: TimeInterval = 0.03 // seconds per character
    
    // State
    private var isAnimating = false
    private var currentText = ""
    private var displayedCharacters = 0
    
    override init() {
        super.init()
        setupDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDisplay() {
        // Create text label
        textLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        textLabel.fontSize = 22
        textLabel.fontColor = .charcoal
        textLabel.numberOfLines = 0
        textLabel.preferredMaxLayoutWidth = 350 // Adjust based on screen width
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        addChild(textLabel)
        
        // Create shadow label for better readability
        shadowLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        shadowLabel!.fontSize = 22
        shadowLabel!.fontColor = .black.withAlphaComponent(0.3)
        shadowLabel!.numberOfLines = 0
        shadowLabel!.preferredMaxLayoutWidth = 350
        shadowLabel!.horizontalAlignmentMode = .center
        shadowLabel!.verticalAlignmentMode = .center
        shadowLabel!.position = CGPoint(x: 2, y: -2)
        shadowLabel!.zPosition = textLabel.zPosition - 1
        addChild(shadowLabel!)
        
        // Initially hidden
        alpha = 0
    }
    
    // MARK: - Public Methods
    
    func showStory(_ moment: StoryMoment, in scene: SKScene, completion: (() -> Void)? = nil) {
        guard !isAnimating else { return }
        
        isAnimating = true
        currentText = moment.text
        displayedCharacters = 0
        
        // Position based on story moment preference
        positionDisplay(for: moment.position, in: scene)
        
        // Create background if needed
        createBackground(for: moment.text)
        
        // Start animation sequence
        run(SKAction.sequence([
            SKAction.fadeIn(withDuration: fadeInDuration),
            SKAction.run { [weak self] in
                self?.startTypewriterEffect()
            },
            SKAction.wait(forDuration: moment.duration),
            SKAction.fadeOut(withDuration: fadeOutDuration),
            SKAction.run { [weak self] in
                self?.isAnimating = false
                self?.removeBackground()
                completion?()
            }
        ]))
    }
    
    func showQuickText(_ text: String, in scene: SKScene, at position: StoryTextPosition = .bottom, duration: TimeInterval = 2.0) {
        let quickMoment = StoryMoment(id: "quick", text: text, duration: duration, position: position)
        showStory(quickMoment, in: scene)
    }
    
    func hideImmediately() {
        removeAllActions()
        alpha = 0
        isAnimating = false
        removeBackground()
    }
    
    // MARK: - Private Methods
    
    private func positionDisplay(for position: StoryTextPosition, in scene: SKScene) {
        switch position {
        case .top:
            self.position = CGPoint(x: scene.frame.midX, y: scene.frame.height - 120)
        case .bottom:
            self.position = CGPoint(x: scene.frame.midX, y: 120)
        case .center:
            self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        }
    }
    
    private func createBackground(for text: String) {
        removeBackground()
        
        // Calculate text size
        let tempLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        tempLabel.fontSize = 22
        tempLabel.text = text
        tempLabel.numberOfLines = 0
        tempLabel.preferredMaxLayoutWidth = 350
        
        let textSize = tempLabel.frame.size
        let backgroundSize = CGSize(
            width: textSize.width + padding * 2,
            height: textSize.height + padding * 2
        )
        
        // Create background shape
        backgroundNode = SKShapeNode(
            rect: CGRect(
                x: -backgroundSize.width / 2,
                y: -backgroundSize.height / 2,
                width: backgroundSize.width,
                height: backgroundSize.height
            ),
            cornerRadius: cornerRadius
        )
        
        backgroundNode!.fillColor = .softWhite.withAlphaComponent(0.95)
        backgroundNode!.strokeColor = .pastelLavender
        backgroundNode!.lineWidth = 2
        backgroundNode!.zPosition = -1
        
        addChild(backgroundNode!)
    }
    
    private func removeBackground() {
        backgroundNode?.removeFromParent()
        backgroundNode = nil
    }
    
    private func startTypewriterEffect() {
        // Clear text initially
        textLabel.text = ""
        shadowLabel?.text = ""
        
        // Create typewriter action
        let typewriterAction = SKAction.customAction(withDuration: Double(currentText.count) * typewriterSpeed) { [weak self] node, elapsedTime in
            guard let self = self else { return }
            
            let progress = elapsedTime / (Double(self.currentText.count) * self.typewriterSpeed)
            let charactersToShow = Int(Double(self.currentText.count) * progress)
            
            if charactersToShow != self.displayedCharacters {
                self.displayedCharacters = charactersToShow
                let displayText = String(self.currentText.prefix(charactersToShow))
                self.textLabel.text = displayText
                self.shadowLabel?.text = displayText
            }
        }
        
        run(typewriterAction)
    }
}

// MARK: - Scene Extension for Easy Story Display

extension SKScene {
    
    private static var storyDisplayKey: UInt8 = 0
    
    var storyDisplay: StoryTextDisplay {
        if let existing = objc_getAssociatedObject(self, &SKScene.storyDisplayKey) as? StoryTextDisplay {
            return existing
        }
        
        let newDisplay = StoryTextDisplay()
        newDisplay.zPosition = 1000 // Always on top
        addChild(newDisplay)
        objc_setAssociatedObject(self, &SKScene.storyDisplayKey, newDisplay, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newDisplay
    }
    
    func showStoryText(_ moment: StoryMoment, completion: (() -> Void)? = nil) {
        storyDisplay.showStory(moment, in: self, completion: completion)
    }
    
    func showQuickStoryText(_ text: String, at position: StoryTextPosition = .bottom, duration: TimeInterval = 2.0) {
        storyDisplay.showQuickText(text, in: self, at: position, duration: duration)
    }
    
    func hideStoryText() {
        storyDisplay.hideImmediately()
    }
}