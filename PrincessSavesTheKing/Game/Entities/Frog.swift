//
//  Frog.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import SpriteKit

// Frog personality types for variety
enum FrogPersonality: String, CaseIterable {
    case lazy = "Lazy"
    case nervous = "Nervous"
    case philosophical = "Philosophical"
    case forgetful = "Forgetful"
    case enthusiastic = "Enthusiastic"
    case sarcastic = "Sarcastic"
    case sleepy = "Sleepy"
    case romantic = "Romantic"
    case wise = "Wise"
}

// Frog data structure
struct FrogData {
    let id: Int
    let name: String
    let personality: FrogPersonality
    let color: UIColor
    let accentColor: UIColor
    let dialogue: String
    let animationStyle: FrogAnimationStyle
}

// Animation styles for different frog behaviors
enum FrogAnimationStyle {
    case idle      // Just sits there
    case hopping   // Regular hopping
    case nervous   // Quick, jittery movements
    case sleepy    // Slow blinking and nodding
    case energetic // Bouncy and active
}

class Frog: SKNode {
    
    // Properties
    private var bodyNode: SKShapeNode!
    private var leftEye: SKShapeNode!
    private var rightEye: SKShapeNode!
    private var leftPupil: SKShapeNode!
    private var rightPupil: SKShapeNode!
    private var mouthNode: SKShapeNode?
    
    var frogData: FrogData
    private var isAnimating = false
    
    // Speech bubble components
    private var speechBubble: SKShapeNode?
    private var dialogueLabel: SKLabelNode?
    
    // Constants
    private let frogSize = CGSize(width: 80, height: 80)
    private let eyeSize: CGFloat = 15
    private let pupilSize: CGFloat = 8
    
    init(frogData: FrogData) {
        self.frogData = frogData
        super.init()
        setupFrog()
        startIdleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFrog() {
        // Create frog body
        bodyNode = SKShapeNode(ellipseOf: frogSize)
        bodyNode.fillColor = frogData.color
        bodyNode.strokeColor = frogData.accentColor
        bodyNode.lineWidth = 3
        addChild(bodyNode)
        
        // Add texture/pattern for variety (optional)
        if frogData.personality == .wise || frogData.personality == .philosophical {
            addSpots()
        }
        
        // Create eyes
        setupEyes()
        
        // Add mouth based on personality
        setupMouth()
    }
    
    private func setupEyes() {
        // Left eye
        leftEye = SKShapeNode(circleOfRadius: eyeSize)
        leftEye.fillColor = .white
        leftEye.strokeColor = .charcoal
        leftEye.position = CGPoint(x: -20, y: 20)
        bodyNode.addChild(leftEye)
        
        // Right eye
        rightEye = SKShapeNode(circleOfRadius: eyeSize)
        rightEye.fillColor = .white
        rightEye.strokeColor = .charcoal
        rightEye.position = CGPoint(x: 20, y: 20)
        bodyNode.addChild(rightEye)
        
        // Left pupil
        leftPupil = SKShapeNode(circleOfRadius: pupilSize)
        leftPupil.fillColor = .charcoal
        leftPupil.strokeColor = .clear
        leftEye.addChild(leftPupil)
        
        // Right pupil
        rightPupil = SKShapeNode(circleOfRadius: pupilSize)
        rightPupil.fillColor = .charcoal
        rightPupil.strokeColor = .clear
        rightEye.addChild(rightPupil)
        
        // Adjust eye appearance based on personality
        switch frogData.personality {
        case .sleepy:
            leftEye.yScale = 0.5
            rightEye.yScale = 0.5
        case .nervous:
            leftPupil.position = CGPoint(x: 0, y: -3)
            rightPupil.position = CGPoint(x: 0, y: -3)
        case .romantic:
            // Heart-shaped pupils
            leftPupil.removeFromParent()
            rightPupil.removeFromParent()
            addHeartPupils()
        default:
            break
        }
    }
    
    private func setupMouth() {
        let mouthPath = CGMutablePath()
        
        switch frogData.personality {
        case .sarcastic:
            // Smirk
            mouthPath.move(to: CGPoint(x: -10, y: -10))
            mouthPath.addQuadCurve(to: CGPoint(x: 15, y: -5), control: CGPoint(x: 5, y: -12))
        case .enthusiastic, .romantic:
            // Big smile
            mouthPath.move(to: CGPoint(x: -20, y: -10))
            mouthPath.addQuadCurve(to: CGPoint(x: 20, y: -10), control: CGPoint(x: 0, y: -20))
        case .lazy, .sleepy:
            // Slight frown
            mouthPath.move(to: CGPoint(x: -15, y: -15))
            mouthPath.addQuadCurve(to: CGPoint(x: 15, y: -15), control: CGPoint(x: 0, y: -10))
        case .nervous:
            // Wavy worried line
            mouthPath.move(to: CGPoint(x: -15, y: -10))
            mouthPath.addLine(to: CGPoint(x: -5, y: -12))
            mouthPath.addLine(to: CGPoint(x: 5, y: -8))
            mouthPath.addLine(to: CGPoint(x: 15, y: -10))
        default:
            // Neutral line
            mouthPath.move(to: CGPoint(x: -10, y: -10))
            mouthPath.addLine(to: CGPoint(x: 10, y: -10))
        }
        
        mouthNode = SKShapeNode(path: mouthPath)
        mouthNode!.strokeColor = .charcoal
        mouthNode!.lineWidth = 2
        mouthNode!.lineCap = .round
        bodyNode.addChild(mouthNode!)
    }
    
    private func addSpots() {
        // Add some spots for wise/philosophical frogs
        for _ in 0..<3 {
            let spot = SKShapeNode(circleOfRadius: CGFloat.random(in: 5...10))
            spot.fillColor = frogData.color.darker()
            spot.strokeColor = .clear
            spot.alpha = 0.5
            spot.position = CGPoint(
                x: CGFloat.random(in: -30...30),
                y: CGFloat.random(in: -20...10)
            )
            bodyNode.addChild(spot)
        }
    }
    
    private func addHeartPupils() {
        // Create heart-shaped pupils for romantic frog
        let heartSize: CGFloat = 10
        
        let leftHeart = createHeartShape(size: heartSize)
        leftHeart.fillColor = .systemPink
        leftEye.addChild(leftHeart)
        
        let rightHeart = createHeartShape(size: heartSize)
        rightHeart.fillColor = .systemPink
        rightEye.addChild(rightHeart)
    }
    
    private func createHeartShape(size: CGFloat) -> SKShapeNode {
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
        
        let heart = SKShapeNode(path: path)
        heart.strokeColor = .clear
        return heart
    }
    
    // MARK: - Animations
    
    func startIdleAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        switch frogData.animationStyle {
        case .idle:
            startBlinking()
        case .hopping:
            startHopping()
        case .nervous:
            startNervousAnimation()
        case .sleepy:
            startSleepyAnimation()
        case .energetic:
            startEnergeticAnimation()
        }
    }
    
    func stopAnimations() {
        isAnimating = false
        removeAllActions()
        bodyNode.removeAllActions()
        leftEye.removeAllActions()
        rightEye.removeAllActions()
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
    
    private func startHopping() {
        startBlinking()
        
        let hop = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 20, duration: 0.3),
            SKAction.moveBy(x: 0, y: -20, duration: 0.3),
            SKAction.wait(forDuration: Double.random(in: 1.5...2.5))
        ])
        bodyNode.run(SKAction.repeatForever(hop))
    }
    
    private func startNervousAnimation() {
        startBlinking()
        
        // Quick eye darting
        let eyeDart = SKAction.sequence([
            SKAction.run { [weak self] in
                let offset = CGFloat.random(in: -5...5)
                self?.leftPupil.position = CGPoint(x: offset, y: 0)
                self?.rightPupil.position = CGPoint(x: offset, y: 0)
            },
            SKAction.wait(forDuration: Double.random(in: 0.1...0.3))
        ])
        run(SKAction.repeatForever(eyeDart))
        
        // Slight shaking
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 2, y: 0, duration: 0.05),
            SKAction.moveBy(x: -4, y: 0, duration: 0.1),
            SKAction.moveBy(x: 2, y: 0, duration: 0.05),
            SKAction.wait(forDuration: Double.random(in: 0.5...1.0))
        ])
        bodyNode.run(SKAction.repeatForever(shake))
    }
    
    private func startSleepyAnimation() {
        // Slow blinking
        let sleepyBlink = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                self?.leftEye.run(SKAction.scaleY(to: 0.3, duration: 0.5))
                self?.rightEye.run(SKAction.scaleY(to: 0.3, duration: 0.5))
            },
            SKAction.wait(forDuration: 0.3),
            SKAction.run { [weak self] in
                self?.leftEye.run(SKAction.scaleY(to: 0.5, duration: 0.3))
                self?.rightEye.run(SKAction.scaleY(to: 0.5, duration: 0.3))
            }
        ])
        run(SKAction.repeatForever(sleepyBlink))
        
        // Gentle swaying
        let sway = SKAction.sequence([
            SKAction.rotate(byAngle: 0.05, duration: 2.0),
            SKAction.rotate(byAngle: -0.1, duration: 4.0),
            SKAction.rotate(byAngle: 0.05, duration: 2.0)
        ])
        bodyNode.run(SKAction.repeatForever(sway))
    }
    
    private func startEnergeticAnimation() {
        startBlinking()
        
        // Bouncy movement
        let bounce = SKAction.group([
            SKAction.sequence([
                SKAction.moveBy(x: 0, y: 30, duration: 0.25),
                SKAction.moveBy(x: 0, y: -30, duration: 0.25)
            ]),
            SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.25),
                SKAction.scale(to: 1.0, duration: 0.25)
            ])
        ])
        
        let energeticSequence = SKAction.sequence([
            bounce,
            SKAction.wait(forDuration: 0.3),
            bounce,
            SKAction.wait(forDuration: 1.0)
        ])
        
        bodyNode.run(SKAction.repeatForever(energeticSequence))
    }
    
    // MARK: - Dialogue System
    
    func showDialogue(completion: (() -> Void)? = nil) {
        // Create speech bubble
        let bubbleWidth: CGFloat = 280
        let bubbleHeight: CGFloat = 100
        let bubblePadding: CGFloat = 20
        
        speechBubble = SKShapeNode(rect: CGRect(x: -bubbleWidth/2, y: -bubbleHeight/2, 
                                               width: bubbleWidth, height: bubbleHeight), 
                                  cornerRadius: 20)
        speechBubble!.fillColor = .white
        speechBubble!.strokeColor = .charcoal.withAlphaComponent(0.3)
        speechBubble!.lineWidth = 2
        speechBubble!.position = CGPoint(x: 0, y: frogSize.height + 40)
        speechBubble!.alpha = 0
        speechBubble!.zPosition = 100
        addChild(speechBubble!)
        
        // Add tail to speech bubble
        let tailPath = CGMutablePath()
        tailPath.move(to: CGPoint(x: -10, y: -bubbleHeight/2))
        tailPath.addLine(to: CGPoint(x: 0, y: -bubbleHeight/2 - 20))
        tailPath.addLine(to: CGPoint(x: 10, y: -bubbleHeight/2))
        
        let tail = SKShapeNode(path: tailPath)
        tail.fillColor = .white
        tail.strokeColor = .charcoal.withAlphaComponent(0.3)
        tail.lineWidth = 2
        speechBubble!.addChild(tail)
        
        // Create dialogue label
        dialogueLabel = SKLabelNode(fontNamed: "Noteworthy-Light")
        dialogueLabel!.fontSize = 16
        dialogueLabel!.fontColor = .charcoal
        dialogueLabel!.text = frogData.dialogue
        dialogueLabel!.numberOfLines = 0
        dialogueLabel!.preferredMaxLayoutWidth = bubbleWidth - bubblePadding * 2
        dialogueLabel!.verticalAlignmentMode = .center
        dialogueLabel!.horizontalAlignmentMode = .center
        speechBubble!.addChild(dialogueLabel!)
        
        // Animate appearance
        let appear = SKAction.group([
            SKAction.fadeIn(withDuration: 0.3),
            SKAction.sequence([
                SKAction.scale(to: 0.8, duration: 0),
                SKAction.scale(to: 1.0, duration: 0.3)
            ])
        ])
        
        speechBubble!.run(SKAction.sequence([
            appear,
            SKAction.wait(forDuration: 3.0),
            SKAction.run {
                completion?()
            }
        ]))
    }
    
    func hideDialogue() {
        guard let bubble = speechBubble else { return }
        
        let disappear = SKAction.group([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.scale(to: 0.8, duration: 0.3)
        ])
        
        bubble.run(SKAction.sequence([
            disappear,
            SKAction.removeFromParent()
        ]))
        
        speechBubble = nil
        dialogueLabel = nil
    }
    
    // MARK: - Special Animations
    
    func performGreeting() {
        // Special animation when meeting the princess
        let greet = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.2),
            SKAction.moveBy(x: 0, y: 30, duration: 0.3),
            SKAction.moveBy(x: 0, y: -30, duration: 0.3)
        ])
        
        bodyNode.run(greet)
    }
}

// MARK: - Frog Factory

class FrogFactory {
    
    static let shared = FrogFactory()
    
    private let frogDefinitions: [FrogData] = [
        FrogData(id: 1,
                name: "Sir Ribbington",
                personality: .lazy,
                color: .pastelEmerald,
                accentColor: .pastelEmerald.darker(),
                dialogue: "The King? Oh, he went for a walk... somewhere. Try the next castle, maybe?",
                animationStyle: .idle),
        
        FrogData(id: 2,
                name: "Professor Hopsworth",
                personality: .philosophical,
                color: .pastelLilac,
                accentColor: .pastelLilac.darker(),
                dialogue: "Is the King truly in another castle, or are we all in castles of our own making?",
                animationStyle: .idle),
        
        FrogData(id: 3,
                name: "Nervous Ned",
                personality: .nervous,
                color: .pastelSunflower,
                accentColor: .pastelSunflower.darker(),
                dialogue: "Oh no, oh no! The King! He was just here! Or was that yesterday? I'm not good under pressure!",
                animationStyle: .nervous),
        
        FrogData(id: 4,
                name: "Lily Paddington",
                personality: .forgetful,
                color: .pastelRose,
                accentColor: .pastelRose.darker(),
                dialogue: "There was something important I was supposed to tell you... Oh! The King! He's in... wait, where was it again?",
                animationStyle: .hopping),
        
        FrogData(id: 5,
                name: "Captain Croak",
                personality: .enthusiastic,
                color: .pastelOcean,
                accentColor: .pastelOcean.darker(),
                dialogue: "PRINCESS! You just missed him! But don't worry, you're getting warmer! Next castle for sure!",
                animationStyle: .energetic),
        
        FrogData(id: 6,
                name: "Duke Dewlap",
                personality: .sarcastic,
                color: .pastelSage,
                accentColor: .pastelSage.darker(),
                dialogue: "Oh sure, the King is totally in the next castle. Just like he was 'totally' in this one. Good luck with that.",
                animationStyle: .idle),
        
        FrogData(id: 7,
                name: "Sleepy Samuel",
                personality: .sleepy,
                color: .pastelPeriwinkle,
                accentColor: .pastelPeriwinkle.darker(),
                dialogue: "Zzz... huh? Oh, the King... *yawn* ...he said something about... another castle... zzz...",
                animationStyle: .sleepy),
        
        FrogData(id: 8,
                name: "Romeo Ribbit",
                personality: .romantic,
                color: .pastelCoral,
                accentColor: .pastelCoral.darker(),
                dialogue: "Ah, true love! How romantic! The King awaits in the next castle, preparing a grand celebration for his heroic daughter!",
                animationStyle: .hopping),
        
        FrogData(id: 9,
                name: "Elder Toadimus",
                personality: .wise,
                color: .pastelMint,
                accentColor: .pastelMint.darker(),
                dialogue: "Patience, young Princess. The journey is long, but the next castle holds what you seek. This I know to be true.",
                animationStyle: .idle)
    ]
    
    func createFrog(forCastle castleNumber: Int) -> Frog {
        // Special handling for castle 10 - the final castle
        if castleNumber == 10 {
            let finalFrogData = FrogData(
                id: 10,
                name: "King's Guard",
                personality: .wise,
                color: .pastelGold,
                accentColor: .pastelGold.darker(),
                dialogue: "The King is here! You found him! He's been waiting for you, brave Princess!",
                animationStyle: .energetic
            )
            return Frog(frogData: finalFrogData)
        }
        
        let index = (castleNumber - 1) % frogDefinitions.count
        let frogData = frogDefinitions[index]
        return Frog(frogData: frogData)
    }
    
    func getFrogData(forCastle castleNumber: Int) -> FrogData {
        let index = (castleNumber - 1) % frogDefinitions.count
        return frogDefinitions[index]
    }
}