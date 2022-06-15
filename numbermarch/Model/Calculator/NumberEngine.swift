
//
//  NumberEngine.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 8/06/22.
//

import Foundation

enum CalculatorState {
    // new digits will be appended
    case enteringNumber
    // next digit will replace whatever's on the screen
    case readyToEnterNewNumber
    // after = pressed and the result is being displayed
    case displayingResult
}

/**
 The NumberEngine handles responding to key input, displaying characters to the screen, clearing the screen.
 */
class NumberEngine {
    
    var delegate: NumberEngineDelegate?
    var screen: ScreenProtocol
    
    /**
     The state of the calculator.
     
     The state will determine how digits are placed on the screen.
     
        - enteringNumber: will ensure new digits are appended to the end
        - readyToEnterNewNumber: will ensure before the next digit is displayed the screen is cleared
     
     Subclasses can set the state according to their needs. For example, a calculator may set the state to readyToEnterNewNumber after the results of a calculation are displayed.
     */
    var state: CalculatorState = .readyToEnterNewNumber {
        didSet(value) {
            print("setting state to \(value)")
        }
    }
    
    init(screen: ScreenProtocol) {
        self.screen = screen
        self.allClear()
        self.state = .readyToEnterNewNumber
    }
    
    /**
     Handle any keys that are pressed.
     
     */
    fileprivate func handleKeyPress(_ key: CalculatorKey) {
        
        if key.isDigit || key == .point {
            
            // Assuming we can find a corresponding digit character to display
            if let digitalCharacter = DigitalCharacter(calculatorKey: key) {
                
                if state == .readyToEnterNewNumber || state == .displayingResult {
                    self.screen.clearScreen()
                }
                
                // prevent another digit being added if we've run out of screen space.
                if self.screen.canAppendWithoutLoss {
                    if digitalCharacter == .point {
                        if self.state == .readyToEnterNewNumber {
                            self.screen.append(.zero)
                        }
                        self.screen.appendDecimalPoint()
                    } else {
                        self.screen.append(digitalCharacter)
                    }
                    self.state = .enteringNumber
                }
                self.delegate?.numberEngine(self, didPressNumberKey: key, appendedToScreen: self.screen.canAppendWithoutLoss)
            }
        } else if key.isOperator {
            delegate?.numberEngine(self, didPressOperationKey: key)
        } else if key == .AC {
            self.allClear()
            
        } else if key == .C {
            self.clear()
            delegate?.numberEngine(self, didPressActionKey: key)
        } else if key == .equals {
            delegate?.numberEngine(self, didPressActionKey: key)
        }
    }
    
    /**
     Equivalent of pressing C. Keeps what's in memory and displays "0." on the screen
     */
    public func clear() {
        self.screen.clearScreen()
        let position = self.screen.numberOfCharacters
        self.screen.display(DigitalCharacter.zero, screenPosition: position)
        self.screen.displayDecimalPoint(position)
        
        // Make sure the next digit replaces the '0.' placeholder
        self.state = .readyToEnterNewNumber
        
        delegate?.numberEngine(self, didPressActionKey: .C)
    }
    
    /**
     Equivalent of pressing AC. Wipes the memory and displays "0." on the screen
     */
    public func allClear() {
        self.clear()
        delegate?.numberEngine(self, didPressActionKey: .AC)
    }

}

extension NumberEngine: KeyboardDelegate {
    func keyPressed(key: CalculatorKey) {
        self.handleKeyPress(key)
    }

}
