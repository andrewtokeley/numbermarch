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
        return UIColor(red: 190/255, green: 195/255, blue: 183/255, alpha: 1)
    }
    
    public class var gameBattlefieldText: UIColor {
        return .black
    }
    
    public class var gameBattlefieldTextBackground: UIColor {
        return UIColor(red: 186/255, green: 191/255, blue: 178/255, alpha: 1)
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
