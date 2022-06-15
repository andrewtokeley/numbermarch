//
//  CalculatorKeyEnum.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 30/05/22.
//

import Foundation
import SpriteKit

/**
 Recognised keys that can be pressed on the calculator
 */
enum CalculatorKey: Int {
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
    case point = 10  // aim
    case plus = 111 // fire
    case minus = 112
    case times = 113
    case divide = 114
    case percent = 115
    case equals = 116
    case MR = 200
    case Mplus = 201
    case Mminus = 202
    case game = 300 // game
    case unknown = 400
    case onoffSwitch = 500
    case AC = 1000
    case C = 1001
    
    /**
     Returns whether the key represents a digit (exludes decimal point)
     */
    var isDigit: Bool {
        return rawValue <= 9
    }
    
    var asText: String {
        if self.isOperator {
            return operatorSymbol ?? ""
        } else if self.isDigit {
            return String(self.rawValue)
        } else if self == .point {
            return "."
        } else {
            return ""
        }
    }
    
    var isAddMinusOperator: Bool {
        return self == .minus || self == .plus
    }
    
    var isMultiplyDivideOperator: Bool {
        return self == .times || self == .divide
    }
    
    /**
     Returns whether the key is an operator
     */
    var isOperator: Bool {
        return self == .plus ||
        self == .minus ||
        self == .times ||
        self == .divide
    }
    
    var operatorSymbol: String? {
        if isOperator {
            if self == .plus { return "+" }
            if self == .minus { return "-" }
            if self == .divide { return "/" }
            if self == .times { return "*" }
        }
        return nil
    }
    /**
     Returns a node that can be displayed on the screen
     
     Returns nil of the key is either a digit, as defined by ``isDigit`` or a point.
     */
    func asDigitalCharacter() -> SKSpriteNode? {
        guard self.isDigit || self == .point else { return nil }
        switch self {
        case .point:
            return DigitalDecimalPointNode()
        default:
            if let node = DigitalCharacter(rawValue: self.rawValue ) {
                return DigitalCharacterNode(character: node)
            }
            return nil
        }
    }
}
