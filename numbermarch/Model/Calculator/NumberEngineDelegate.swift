//
//  NumberEngineDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 12/06/22.
//

import Foundation

protocol NumberEngineDelegate {
    
    /**
     Called whenever an operator key is pressed, this includes +, -, / or *
     */
    func numberEngine(_ engine: NumberEngine, didPressOperationKey key: CalculatorKey)
    
    /**
     Called when an action key is pressed.
     
     For example, =, M+, M-, C, AC...
     */
    func numberEngine(_ engine: NumberEngine, didPressActionKey key: CalculatorKey)
    
    /**
     Called when a number key was pressed
     
     - Parameters:
        - engine
        - didPressNumberKey: represents the key that was pressed
        - appendedToScreen: returns true if the key pressed was printed to the screen. If the screen is full this delegate method will still be called even if the screen doesn't update.
     */
    func numberEngine(_ engine: NumberEngine, didPressNumberKey key: CalculatorKey, appendedToScreen: Bool)
}
