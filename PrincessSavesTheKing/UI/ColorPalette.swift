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
    
    // Castle/Accent Colors
    static let accentOrange = UIColor(red: 1.0, green: 0.65, blue: 0.40, alpha: 1.0)  // #FFA666
    static let emerald = UIColor(red: 0.40, green: 0.75, blue: 0.50, alpha: 1.0)      // #66BF80
    
    // Additional pastel colors for frog variations
    static let sunflower = UIColor(red: 1.0, green: 0.92, blue: 0.60, alpha: 1.0)     // #FFEB99
    static let rose = UIColor(red: 1.0, green: 0.80, blue: 0.82, alpha: 1.0)          // #FFCCD1
    static let ocean = UIColor(red: 0.60, green: 0.80, blue: 0.90, alpha: 1.0)        // #99CCE6
    static let periwinkle = UIColor(red: 0.80, green: 0.80, blue: 0.95, alpha: 1.0)   // #CCCEF2
    static let gold = UIColor(red: 1.0, green: 0.85, blue: 0.50, alpha: 1.0)          // #FFD980
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
    static let pastelAccentOrange = SKColor(cgColor: ColorPalette.accentOrange.cgColor)
    static let pastelEmerald = SKColor(cgColor: ColorPalette.emerald.cgColor)
    static let pastelSunflower = SKColor(cgColor: ColorPalette.sunflower.cgColor)
    static let pastelRose = SKColor(cgColor: ColorPalette.rose.cgColor)
    static let pastelOcean = SKColor(cgColor: ColorPalette.ocean.cgColor)
    static let pastelPeriwinkle = SKColor(cgColor: ColorPalette.periwinkle.cgColor)
    static let pastelGold = SKColor(cgColor: ColorPalette.gold.cgColor)
}

// Helper extensions
extension UIColor {
    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return UIColor(hue: hue,
                      saturation: saturation,
                      brightness: brightness * (1 - percentage),
                      alpha: alpha)
    }
}