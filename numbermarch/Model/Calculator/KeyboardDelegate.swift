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

    

