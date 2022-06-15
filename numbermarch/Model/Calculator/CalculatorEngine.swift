//
//  CalculatorEngine.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 8/06/22.
//

import Foundation
import MathExpression

class CalculatorEngine: NumberEngine {

    /**
     The mathematical expression builder
     */
    private var expression: ExpressionBuilder
    
    /**
     The result of evaluating the expression
     */
    private var result: Double = 0

    private var displayingResult: Bool = false
    
    /**
     Initialise a new CalculatorEngine
     */
    override init(screen: ScreenProtocol) {
        self.expression = ExpressionBuilder()
        super.init(screen: screen)
        self.delegate = self
    }
    
    /**
     Resolve the current expression
     */
    private func resolveExpression(_ expression: String) {
        print(expression)
        
        do {
            let math = try MathExpression(expression)
            result = math.evaluate()
            print("Expression = \(expression)")
            print("MathExpression.evaluate = \(result)")
            let formater = NumberFormatter()
            formater.maximumIntegerDigits = 8
            formater.maximumFractionDigits = 8
            
            if let resultAsString = formater.string(from: NSNumber(value: result)) {
                print("As String = \(resultAsString)")
                var screenValue = resultAsString
                if resultAsString.count > self.screen.numberOfCharacters {
                    screenValue = String(resultAsString[0...self.screen.numberOfCharacters])
                }
                print("Truncated to Screen Size = \(screenValue)")
                self.screen.clearScreen(includingMessageText: false)
                self.screen.display(screenValue)
                
                // ensure the next digit entered will clear the screen
                self.state = .readyToEnterNewNumber
                
                // store the value in the expression so it can be part of the next operation
                self.expression.allClear()
                self.expression.addNumber(result)
                self.displayingResult = true
                
            } else {
                print("Can't convert to string")
            }
        } catch {
            guard let error = error as? MathExpression.ValidationError else {
                fatalError("[MathExpressionViewModel] Expression \(expression) returned unknown error during validation!")
            }
            self.expression.allClear()
            print(error)
        }
        
    }
    
}

extension CalculatorEngine: NumberEngineDelegate {
    
    func numberEngine(_ engine: NumberEngine, didPressNumberKey key: CalculatorKey, appendedToScreen: Bool) {

        // if the number wasn't sent to the screen we ignore it
        guard appendedToScreen else { return }
        
        // If we have just entered a digit after display the result of another calc then reset everything.
        if self.displayingResult {
            self.expression.allClear()
            self.displayingResult = false
        }
        
        self.expression.add(key)
        self.state = .enteringNumber
        self.screen.displayTextMessage(text: self.expression.expression)
    }
    
    func numberEngine(_ engine: NumberEngine, didPressActionKey key: CalculatorKey) {
        if key == .equals {
            self.resolveExpression(self.expression.expression)
        } else if key == .AC {
            self.expression.allClear()
            //self.screen.displayTextMessage(text: self.expression.expression)
        } else if key == .C {
            self.expression.clear()
        }
        
    }
    
    func numberEngine(_ engine: NumberEngine, didPressOperationKey key: CalculatorKey) {
        self.displayingResult = false
        self.expression.add(key)
        self.state = .readyToEnterNewNumber
        self.screen.displayTextMessage(text: self.expression.expression)
    }
        
}
