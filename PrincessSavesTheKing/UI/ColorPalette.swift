//
//  ColorPalette.swift
//  PrincessSavesTheKing
//
//  Created by Chris Carella on 8/4/25.
//

import UIKit
import SpriteKit

struct ColorPalette {
    // Pastel Background Gradient Colors
    static let skyBlue = UIColor(red: 0.68, green: 0.85, blue: 0.96, alpha: 1.0)      // #AED9F5
    static let lavender = UIColor(red: 0.82, green: 0.76, blue: 0.91, alpha: 1.0)     // #D1C2E8
    static let peach = UIColor(red: 1.0, green: 0.87, blue: 0.80, alpha: 1.0)         // #FFDECC
    static let mint = UIColor(red: 0.74, green: 0.92, blue: 0.84, alpha: 1.0)         // #BDEBD6
    
    // UI Element Colors
    static let coral = UIColor(red: 1.0, green: 0.73, blue: 0.73, alpha: 1.0)         // #FFBABA
    static let lilac = UIColor(red: 0.78, green: 0.70, blue: 0.85, alpha: 1.0)        // #C7B3D9
    static let buttercream = UIColor(red: 1.0, green: 0.96, blue: 0.82, alpha: 1.0)   // #FFF5D1
    static let sage = UIColor(red: 0.76, green: 0.84, blue: 0.74, alpha: 1.0)         // #C2D6BD
    
    // Text Colors
    static let softWhite = UIColor(red: 0.98, green: 0.98, blue: 0.96, alpha: 1.0)    // #FAFAF5
    static let charcoal = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)     // #404047
    
    // Player & Obstacle Colors
    static let playerPink = UIColor(red: 1.0, green: 0.80, blue: 0.86, alpha: 1.0)    // #FFCCDB
    static let obstacleBlue = UIColor(red: 0.67, green: 0.76, blue: 0.89, alpha: 1.0) // #ABC3E3
    
    // Ground Color
    static let groundGreen = UIColor(red: 0.65, green: 0.82, blue: 0.65, alpha: 1.0)  // #A6D1A6
}

// SKColor extensions for easy use in SpriteKit
extension SKColor {
    static let pastelSkyBlue = SKColor(cgColor: ColorPalette.skyBlue.cgColor)
    static let pastelLavender = SKColor(cgColor: ColorPalette.lavender.cgColor)
    static let pastelPeach = SKColor(cgColor: ColorPalette.peach.cgColor)
    static let pastelMint = SKColor(cgColor: ColorPalette.mint.cgColor)
    static let pastelCoral = SKColor(cgColor: ColorPalette.coral.cgColor)
    static let pastelLilac = SKColor(cgColor: ColorPalette.lilac.cgColor)
    static let pastelButtercream = SKColor(cgColor: ColorPalette.buttercream.cgColor)
    static let pastelSage = SKColor(cgColor: ColorPalette.sage.cgColor)
    static let softWhite = SKColor(cgColor: ColorPalette.softWhite.cgColor)
    static let charcoal = SKColor(cgColor: ColorPalette.charcoal.cgColor)
    static let pastelPlayerPink = SKColor(cgColor: ColorPalette.playerPink.cgColor)
    static let pastelObstacleBlue = SKColor(cgColor: ColorPalette.obstacleBlue.cgColor)
    static let pastelGroundGreen = SKColor(cgColor: ColorPalette.groundGreen.cgColor)
}