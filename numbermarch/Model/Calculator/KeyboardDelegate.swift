//
//  KeyboardDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

/**
 Implementations of this delegate will be notified of key press events on the calculator
 */
protocol KeyboardDelegate {
    func keyPressed(key: CalculatorKey)
}

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
    case point = 10 // aim
    case plus = 11 // fire
    case game = 12 // game
}

