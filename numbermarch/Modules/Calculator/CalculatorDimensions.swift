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
    var buttonVerticalDistanceBetween: CGFloat = 5
    var buttonVerticalDistanceToTopRow: CGFloat = 6
    var buttonHorizontalDistanceBetween: CGFloat = 4
    var buttonsDistanceFromVerticalEdge: CGFloat = 7
    var buttonsDistanceFromBottomEdge: CGFloat = 7
}

class CalculatorDimensions {
        
    public let original = CalculatorMeasurements()
    
    /**
     The ratio by which to multiple original measures to get the corresponding screen measures.
     */
    var ratio: CGFloat
    
    init(width: CGFloat) {
        
        self.ratio = width/original.width
        
        // force the wxh ratio based on the original MG-880
        self.size = CGSize(width: width, height: original.height * ratio)
    }

    /**
     Outer size of the calculator
     */
    var size: CGSize
    
    /**
     Size of the crystal screen within which the app will project digits
     */
    var screenSize: CGSize {
        return CGSize(width: original.screenWidth * ratio, height: original.screenHeight * ratio)
    }
    
    /**
     Distance from the top edge of the calculator to the top of the screen
     */
    var distanceFromTopToScreenTop: CGFloat {
        return original.distanceFromTopToScreen * ratio
    }
    
    /**
     Size of the button
     */
    var buttonSize: CGSize {
        return CGSize(width: original.buttonWidth * ratio, height: original.buttonHeight * ratio)
    }
    
    
    /**
     Returns the key corresponding to the point provided
     
     - Parameters:
        - point: a point in the calculator's coordinate system
     
     Note the calculators coordinate system has its origin (0,0) at its centre
     */
    func keyAt(_ point: CGPoint) -> CalculatorKey? {
        
        // transform x,y into original coordinates and where (0,0) is the bottom left of the view
        let x = (point.x + self.size.width/2) / ratio
        let y = (point.y + self.size.height/2) / ratio
        let point = CGPoint(x: x, y: y)
        
        let hitZoneWidth = original.buttonHorizontalDistanceBetween + original.buttonWidth
        let hitZoneHeight = original.buttonVerticalDistanceBetween + original.buttonHeight
        let hitZone = CGRect(
            x: original.buttonsDistanceFromVerticalEdge - original.buttonHorizontalDistanceBetween,
            y: original.buttonsDistanceFromBottomEdge - original.buttonVerticalDistanceBetween,
            width: 6 * hitZoneWidth,
            height: 6 * hitZoneHeight)
        
        if hitZone.contains(point) {
            let column = Int(trunc((x - hitZone.origin.x - original.buttonHorizontalDistanceBetween/2) / hitZoneWidth)) + 1
            let row = Int(trunc((y - hitZone.origin.y - original.buttonVerticalDistanceBetween/2) / hitZoneHeight)) + 1
            
            return key(row: row, column: column)
        }
        
        return nil
        
        
    }
    
    /**
     Returns the centre point of a button assuming the calculator's original (0, 0) is at its centre
     
     - Parameters:
        - row: the row number, where 1 is the bottom most row and 5 is the top row
        - column: the column number, where 1 is the left most column and 5 is the right most.
     */
    func key(row: Int, column: Int) -> CalculatorKey? {
        guard row >= 1 && row <= 5 && column >= 1 && column <= 5 else { return nil }
        
        let keys = [
            [CalculatorKey.unknown, CalculatorKey.zero, CalculatorKey.point, CalculatorKey.unknown, CalculatorKey.plus],
            [CalculatorKey.unknown, CalculatorKey.one, CalculatorKey.two, CalculatorKey.three, CalculatorKey.unknown],
            [CalculatorKey.unknown, CalculatorKey.four, CalculatorKey.five, CalculatorKey.six, CalculatorKey.unknown],
            [CalculatorKey.game, CalculatorKey.seven, CalculatorKey.eight, CalculatorKey.nine, CalculatorKey.unknown],
            [CalculatorKey.onoffSwitch, CalculatorKey.onoffSwitch, CalculatorKey.unknown, CalculatorKey.unknown, CalculatorKey.unknown]
        ]
        
        return keys[row-1][column-1]
    }
    
}
