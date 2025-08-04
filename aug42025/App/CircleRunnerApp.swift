//
//  CircleRunnerApp.swift
//  CircleRunner
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("AppDelegate: didFinishLaunchingWithOptions")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .green // Green to debug window visibility
        
        let viewController = GameViewController()
        viewController.view.backgroundColor = .yellow // Yellow to debug view controller
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        print("AppDelegate: Window created and made visible")
        print("AppDelegate: Window frame: \(window?.frame ?? .zero)")
        print("AppDelegate: Root VC: \(window?.rootViewController)")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive
    }
}