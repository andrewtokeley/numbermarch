//
//  CalculatorDimensions.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 4/06/22.
//

import Foundation

struct CalculatorMeasurements {
    var width: CGFloat = 100
    var height: CGFloat = 165
    var screenWidth: CGFloat = 66
    var screenHeight: CGFloat = 18
    var distanceFromTopToScreen: CGFloat = 11
    var buttonHeight: CGFloat = 10
    var buttonWidth: CGFloat = 14
    var buttonsRectangle: CGRect = CGRect(x: 7, y: 7, width: 85, height: 76)
}

class CalculatorDimensions {
        
    let original = CalculatorMeasurements()
    
    init(width: CGFloat) {
        // force the wxh ratio based on the original MG-880
        self.size = CGSize(width: width, height: width * original.height/original.width)
    }

    /**
     Outer size of the calculator
     */
    var size: CGSize
    
    /**
     Size of the crystal screen within which the app will project digits
     */
    var screenSize: CGSize {
        return CGSize(width: self.size.width * 66/100, height: self.size.height * original.screenHeight/original.height)
    }
    
    /**
     Returns the position of the centre of the screen
     */
    var positionOfScreen: CGPoint {
        return CGPoint(x: self.size.width/2, y: self.size.height/2 - original.distanceFromTopToScreen - original.screenHeight/2)
    }
    
    var distanceFromTopToScreenTop: CGFloat {
        return self.size.height * original.distanceFromTopToScreen/original.height
    }
    /**
     Returns the key corresponding to the point location provided
     
     Point is assumed to be in the calculators coordinate system where (0,0) is at the centre of the calculator
     */
    func keyAt(_ point: CGPoint) -> CalculatorKey? {
        if point.y > 0.3 * self.size.height {
            return CalculatorKey.game
        }
        if point.x < self.size.width/2 {
            return CalculatorKey.point
        } else {
            return CalculatorKey.plus
        }
    }
    
    /**
     Returns the centre point of a button assuming the calculator's original (0, 0) is at its centre
     */
    func key(row: Int, column: Int) -> CalculatorKey? {
        guard row >= 0 && row <= 4 && column >= 0 && column <= 4 else { return nil }
        
        let keys = [
            [CalculatorKey.plus, CalculatorKey.unknown, CalculatorKey.point, CalculatorKey.zero, CalculatorKey.unknown],
            [CalculatorKey.unknown, CalculatorKey.three, CalculatorKey.two, CalculatorKey.one, CalculatorKey.unknown],
            [CalculatorKey.unknown, CalculatorKey.six, CalculatorKey.five, CalculatorKey.four, CalculatorKey.unknown],
            [CalculatorKey.unknown, CalculatorKey.nine, CalculatorKey.eight, CalculatorKey.seven, CalculatorKey.game],
            [CalculatorKey.unknown, CalculatorKey.unknown, CalculatorKey.unknown, nil, nil]
        ]
        
        return keys[row][column]
    }
    
}
