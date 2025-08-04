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
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .black
        self.view = skView
        print("GameViewController: loadView - created SKView with frame: \(skView.frame)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GameViewController: viewDidLoad started")
        
        // Configure the view
        guard let skView = self.view as? SKView else {
            print("GameViewController: ERROR - view is not SKView")
            return
        }
        
        print("GameViewController: SKView confirmed, bounds: \(skView.bounds)")
        
        // Show debug info in debug builds
        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true
        skView.showsPhysics = false
        #endif
        
        // Optimize rendering
        skView.ignoresSiblingOrder = true
        
        // Create and present the menu scene
        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .black
        
        // Add a simple test to verify SKView is working
        skView.backgroundColor = .darkGray
        
        print("GameViewController: Presenting MenuScene with size: \(scene.size)")
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("GameViewController: viewDidAppear - view frame: \(view.frame)")
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