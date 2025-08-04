//
//  GameViewController.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func loadView() {
        // Create and configure the SKView
        let skView = SKView()
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        guard let skView = self.view as? SKView else {
            return
        }
        
        // Show debug info in debug builds
        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        #endif
        
        // Optimize rendering
        skView.ignoresSiblingOrder = true
        
        // Create and present the menu scene
        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Update scene size on layout changes
        if let skView = self.view as? SKView,
           let scene = skView.scene {
            scene.size = skView.bounds.size
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
}