//
//  GameViewController.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GameViewController: viewDidLoad started")
        
        // Create SKView
        let skView = SKView(frame: view.bounds)
        skView.backgroundColor = .red // Red background to verify view is visible
        view.addSubview(skView)
        
        print("GameViewController: Created SKView with red background")
        
        // Create a simple test scene
        let scene = SKScene(size: view.bounds.size)
        scene.backgroundColor = .blue // Blue scene background
        
        // Add a white label
        let label = SKLabelNode(text: "TEST SCENE")
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(label)
        
        print("GameViewController: Created test scene with label")
        
        // Present the scene
        skView.presentScene(scene)
        
        print("GameViewController: Scene presented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}