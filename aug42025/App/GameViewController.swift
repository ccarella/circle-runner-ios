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
        
        // Configure the view
        if let view = self.view as? SKView {
            // Show debug info in debug builds
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsDrawCount = true
            #endif
            
            // Optimize rendering
            view.ignoresSiblingOrder = true
            
            // Create and present the menu scene
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Update scene size on layout changes
        if let view = self.view as? SKView,
           let scene = view.scene {
            scene.size = view.bounds.size
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