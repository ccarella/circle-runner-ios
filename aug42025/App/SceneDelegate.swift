//
//  SceneDelegate.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate: scene willConnectTo")
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .green
        
        let viewController = GameViewController()
        viewController.view.backgroundColor = .yellow
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        print("SceneDelegate: Window configured and made visible")
    }
}