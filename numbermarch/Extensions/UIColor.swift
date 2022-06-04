//
//  TileColour.swift
//  play2048
//
//  Created by Andrew Tokeley on 10/12/19.
//  Copyright © 2019 Andrew Tokeley. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    // MARK: - App colours
    
    public class var gameBackground: UIColor {
        return .darkGray
    }
    
    public class var gameBattlefield: UIColor {
        //return UIColor(red: 190/255, green: 195/255, blue: 183/255, alpha: 1)
        //return UIColor(red: 163/255, green: 160/255, blue: 146/255, alpha: 1)
        return .red
    }
    
    public class var gameBattlefieldText: UIColor {
        return .black
    }
    
    public class var gameBattlefieldTextBackground: UIColor {
        //return UIColor(red: 186/255, green: 191/255, blue: 178/255, alpha: 1)
        return .calculatorScreen
    }
    
    public class var calculatorBackground: UIColor {
        return UIColor(red: 243/255, green: 248/255, blue: 252/255, alpha: 1)
    }
    
    public class var calculatorScreenOuterBorder: UIColor {
        return UIColor(red: 211/255, green: 205/255, blue: 193/255, alpha: 1)
    }
    
    public class var calculatorScreen: UIColor {
        //return UIColor(red: 186/255, green: 191/255, blue: 178/255, alpha: 1)
        return UIColor(red: 163/255, green: 160/255, blue: 146/255, alpha: 1)
    }
    
    public class var calculatorScreenBorder: UIColor {
        return UIColor(red: 96/255, green: 119/255, blue: 151/255, alpha: 1)
    }
    
    public class var calculatorKeyGray: UIColor {
        return UIColor(red: 35/255, green:26/255, blue:20/255, alpha: 1)
    }
    
    public class var calculatorKeyBlue: UIColor {
        return UIColor(red: 32/255, green:63/255, blue:140/255, alpha: 1)
    }
    
    public class var calculatorKeySteel: UIColor {
        return UIColor(red: 244/255, green:249/255, blue:254/255, alpha: 1)
    }
    
    // MARK: - Instance functions
    
    func toComponents() -> ColorComponents {
        var components = ColorComponents()
        getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
        return components
    }
    
    // MARK: - Static functions
    
    static func lerp(a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat
    {
        return (b-a) * fraction + a
    }
    
}

struct ColorComponents {
    var red = CGFloat(0)
    var green = CGFloat(0)
    var blue = CGFloat(0)
    var alpha = CGFloat(0)
}
