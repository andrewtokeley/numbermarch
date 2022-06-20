//
//  MG775Skin.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 19/06/22.
//

import Foundation
import SpriteKit

/**
 The distances in mm of the original calculator.
 */
struct MG775_Measurements: CalculatorMeasurements {
    var width: CGFloat = 125
    var height: CGFloat = 210
    var screenWidth: CGFloat = 77
    var screenHeight: CGFloat = 22
    var distanceFromTopToScreen: CGFloat = 17
    var buttonRows: Int = 5
    var buttonColumns: Int = 5
    var buttonHeight: CGFloat = 11
    var buttonWidth: CGFloat = 14
    var buttonVerticalDistanceBetween: CGFloat = 10
    var buttonVerticalDistanceToTopRow: CGFloat = 10
    var buttonHorizontalDistanceBetween: CGFloat = 9
    var buttonsDistanceFromVerticalEdge: CGFloat = 8
    var buttonsDistanceFromBottomEdge: CGFloat = 48
    
    var switchWidth: CGFloat = 15
    var switchHeight: CGFloat = 11
    var switchDistanceFromBottom: CGFloat = 130
    var switchDistanceToLeftEdge: CGFloat = 20
}

class MG775Skin: CalculatorSkin {
    
    var screenSize: Int {
        return 8
    }
    
    public var width: CGFloat
    
    private var originalMeasurements: CalculatorMeasurements {
        return MG775_Measurements()
    }
    
    convenience init() {
        self.init(width: 100)
    }
    
    init(width: CGFloat) {
        self.width = width
    }
    
    // MARK: - CalculatorSkin Protocol
    
    var name: String {
        return "MG-775"
    }
    
    var description: String {
        return """
            The original and still the best – Casio’s MG-880 was released in August 1980 and began a decade of integration of calculators and games for the Casio company and its competitors.
        
            The Game is Digital Invaders, match your number on the left with on coming invaders, shot and kill!
        """
    }
    
   var calculatorTexture: SKTexture {
        return SKTexture(imageNamed: "MG-775")
    }
    
    var image: UIImage? {
        return UIImage(named: "MG-775")
    }
    
    func switchTexture(_ position: CalculatorSwitchPosition) -> SKTexture {
        if position == .off {
            return SKTexture(imageNamed: "MG-775-SwitchOff")
        } else if position == .on1 {
            return SKTexture(imageNamed: "MG-775-SwitchMusic")
        } else if position == .on2 {
            return SKTexture(imageNamed: "MG-775-SwitchCalc")
        } else {
            return SKTexture(imageNamed: "MG-775-SwitchOff")
        }
    }
    
    func calculatorEngine(_ screen: ScreenProtocol) -> CalculatorEngine? {
        return CalculatorEngine(screen: screen)
    }
    
    func musicEngine(_ screen: ScreenProtocol) -> MusicEngine? {
        return MusicEngine(screen: screen)
    }
    
    func gameEngine(_ screen: ScreenProtocol) -> GamesProtocol? {
        return EightAttack(screen: screen, rules: ClassicEightAttackRules())
    }
    
    var dimensions: CalculatorDimensions {
        return CalculatorDimensions(width: self.width, originalMeasurements: self.originalMeasurements)
    }
    
    func keyAt(_ point: CGPoint) -> CalculatorKey? {
        return self.dimensions.keyAt(point)
    }
    
}
