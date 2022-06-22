//
//  MG885Skin.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 19/06/22.
//

import Foundation
import SpriteKit

/**
 The distances in mm of the original calculator.
 */
struct MG_885_Measurements: CalculatorMeasurements {
    var width: CGFloat = 120
    var height: CGFloat = 188
    var screenWidth: CGFloat = 71
    var screenHeight: CGFloat = 18
    var distanceFromTopToScreen: CGFloat = 13
    var buttonRows: Int = 5
    var buttonColumns: Int = 5
    var buttonHeight: CGFloat = 14
    var buttonWidth: CGFloat = 17
    var buttonVerticalDistanceBetween: CGFloat = 6
    var buttonVerticalDistanceToTopRow: CGFloat = 6
    var buttonHorizontalDistanceBetween: CGFloat = 4
    var buttonsDistanceFromVerticalEdge: CGFloat = 8
    var buttonsDistanceFromBottomEdge: CGFloat = 7
    
    var switchWidth: CGFloat = 17
    var switchHeight: CGFloat = 11
    var switchDistanceFromBottom: CGFloat = 87
    var switchDistanceToLeftEdge: CGFloat = 19
}


class MG885Skin: CalculatorSkin {
    
    required init(width: CGFloat) {
        self.width = width
    }
    
    private var originalMeasurements: CalculatorMeasurements {
        return MG_885_Measurements()
    }
    
    // MARK: - CalculatorSkin Protocol
    
    var name: String {
        return "MG-885"
    }
    
    var screenSize: Int {
        return 8
    }
    
    var width: CGFloat
    
    var description: String {
        return """
            The original and still the best – Casio’s MG-880 was released in August 1980 and began a decade of integration of calculators and games for the Casio company and its competitors.
        
            The Game is Digital Invaders, match your number on the left with on coming invaders, shot and kill!
        """
    }
    
    var calculatorTexture: SKTexture {
        return SKTexture(imageNamed: "MG-885")
    }
    
    var image: UIImage? {
        return UIImage(named: "MG-885")
    }
    
    func switchTexture(_ position: CalculatorSwitchPosition) -> SKTexture {
        if position == .off {
            return SKTexture(imageNamed: "MG-880-SwitchOff")
        } else if position == .on1 {
            return SKTexture(imageNamed: "MG-880-SwitchMusic")
        } else if position == .on2 {
            return SKTexture(imageNamed: "MG-880-SwitchCalc")
        } else {
            return SKTexture(imageNamed: "MG-880-SwitchOff")
        }
    }
    
    func engineForSwitchPosition(_ switchPosition: CalculatorSwitchPosition, screen: ScreenProtocol) -> NumberEngine? {
        if switchPosition == .off {
            return nil
        } else if switchPosition == .on1 {
            return CalculatorEngine(screen: screen)
        } else if switchPosition == .on2 {
            return CalculatorEngine(screen: screen)
        }
        return nil
    }
    
//    func switch1Engine(_ screen: ScreenProtocol) -> NumberEngine? {
//        return CalculatorEngine(screen: screen)
//    }
//
//    func switch2Function(_ screen: ScreenProtocol) -> NumberEngine? {
//        return CalculatorEngine(screen: screen)
//    }
    
    func game(_ screen: ScreenProtocol) -> GamesProtocol? {
        return EightAttack(screen: screen, rules: ClassicEightAttackRules())
    }
    
    var dimensions: CalculatorDimensions {
        return CalculatorDimensions(width: self.width, originalMeasurements: self.originalMeasurements)
    }
    
    func keyAt(_ point: CGPoint) -> CalculatorKey? {
        return self.dimensions.keyAt(point)
    }
    
    func subText(_ position: Int) -> String? {
        return String(self.screenSize - (position - 1))
    }
}

