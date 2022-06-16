//
//  DigitalCharacter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 12/06/22.
//

import Foundation

/**
 Enumeration that represents a character that can be displayed on a screen
 */
enum DigitalCharacter: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case mothership
    case threebars
    case twobars
    case onebar
    case space
    case point
    case upsideDownA
    case A
    case missileTop
    case missileMiddle
    case missileBottom
    
    var isDigit: Bool {
        return self.rawValue <= 10
    }
    
    /**
     Used to return a string representation of a character, if it exists.
     */
    var asText: String? {
        if isDigit {
            // scary assumption that the order of digits sit in the first 0-9 locations of enum!
            return String(rawValue)
        } else if self == .point {
            return "."
        } else if self == .onebar {
            return "-"
        }
        return nil
    }
    
    /**
     Convenience constructor to convert a calculator key into a digital key enum
     */
    init?(calculatorKey: CalculatorKey) {
        if calculatorKey.isDigit {
            self.init(rawValue: calculatorKey.rawValue)
            return
        } else if calculatorKey == .point {
            self.init(rawValue: 15)
            return
        }
        return nil
    }
    
}
