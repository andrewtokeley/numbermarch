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
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case mothership = 10
    case threebars = 11
    case twobars = 12
    case onebar = 13
    case space = 14
    case point = 15
    case upsideDownA = 16
    case A = 17
    
    var isDigit: Bool {
        return self.rawValue <= 10
    }
    
    var asText: String? {
        if isDigit {
            return String(rawValue)
        } else if self == .point {
            return "."
        } else if self == .onebar {
            return "-"
        }
        return nil
    }
    
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
