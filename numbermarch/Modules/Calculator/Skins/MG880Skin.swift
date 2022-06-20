//
//  MG880-CalculatorSkin.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 19/06/22.
//

import Foundation
import SpriteKit

/**
 The distances in mm of the original calculator.
 */
struct MG_880_Measurements: CalculatorMeasurements {
    var width: CGFloat = 100
    var height: CGFloat = 165
    var screenWidth: CGFloat = 66
    var screenHeight: CGFloat = 18
    var distanceFromTopToScreen: CGFloat = 11
    var buttonRows: Int = 5
    var buttonColumns: Int = 5
    var buttonHeight: CGFloat = 10
    var buttonWidth: CGFloat = 14
    var buttonVerticalDistanceBetween: CGFloat = 5
    var buttonVerticalDistanceToTopRow: CGFloat = 6
    var buttonHorizontalDistanceBetween: CGFloat = 4
    var buttonsDistanceFromVerticalEdge: CGFloat = 7
    var buttonsDistanceFromBottomEdge: CGFloat = 7
    
    var switchWidth: CGFloat = 14
    var switchHeight: CGFloat = 10
    var switchDistanceFromBottom: CGFloat = 72
    var switchDistanceToLeftEdge: CGFloat = 16.5
}


class MG880Skin: CalculatorSkin {
    
    var screenSize: Int {
        return 9
    }
    
    public var width: CGFloat = 0
    
    private var originalMeasurements: CalculatorMeasurements {
        return MG_880_Measurements()
    }
    
    convenience init() {
        self.init(width: 100)
    }
    
    init(width: CGFloat) {
        self.width = width
    }
    
    // MARK: - CalculatorSkin Protocol
    
    var name: String {
        return "MG-880"
    }
    
    var description: String {
        return """
            The original and still the best – Casio’s MG-880 was released in August 1980 and began a decade of integration of calculators and games for the Casio company and its competitors.
        
            The Game is Digital Invaders, match your number on the left with on coming invaders, shot and kill!
        """
    }
    
    var calculatorTexture: SKTexture {
        return SKTexture(imageNamed: "MG-880")
    }
    
    var image: UIImage? {
        return UIImage(named: "MG-880")
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
    
    func calculatorEngine(_ screen: ScreenProtocol) -> CalculatorEngine? {
        return CalculatorEngine(screen: screen)
    }
    
    func musicEngine(_ screen: ScreenProtocol) -> MusicEngine? {
        return MusicEngine(screen: screen)
    }
    
    func gameEngine(_ screen: ScreenProtocol) -> GamesProtocol? {
        return SpaceInvaders(screen: screen, rules: DigitalInvadersClassicRules())
    }
    
    var dimensions: CalculatorDimensions {
        return CalculatorDimensions(width: self.width, originalMeasurements: self.originalMeasurements)
    }
    
    func keyAt(_ point: CGPoint) -> CalculatorKey? {
        return self.dimensions.keyAt(point)
    }
    
}
