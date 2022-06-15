//
//  ExpressionBuilder.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation
import MathExpression

class ExpressionBuilder {
    
    public var expression: String {
        return keys.reduce("",  { $0 + $1.asText } )
    }
    
    private var keys: [CalculatorKey]
    
    init() {
        self.keys = [CalculatorKey]()
    }
    
    public func add(_ key: CalculatorKey) {
        if self.canAdd(key) {
            if self.keys.count == 0 && key == .point {
                self.keys.append(.zero)
            }
            self.keys.append(key)
        } else if canReplaceLast(key) {
            self.keys.removeLast()
            self.keys.append(key)
        }
    }
    
    public func  addNumber(_ number: Double) {
        let numberString = NSNumber(value: number).stringValue
        numberString.forEach { c in
            if let value = Int(String(c)) {
                if let key = CalculatorKey(rawValue: value) {
                    self.add(key)
                }
            } else if c == "." {
                self.add(.point)
            }
        }
    }
    
    public func clear() {
        while keys.last?.isDigit ?? false {
            keys.removeLast()
        }
    }
    
    public func allClear() {
        self.keys.removeAll()
    }
    
    private func canAdd(_ key: CalculatorKey) -> Bool {
        
        if let last = keys.last {
            
            // Can never add an operator after * or /
            if last.isMultiplyDivideOperator && key.isOperator {
                print("can't add operator")
                return false
            }
            
            // Can never add a decimal to anything but a digit
            if !last.isDigit && key == .point {
                print("can't add decimal")
                return false
            }
            
        } else {
            
            // Can only add +, - or a digit to an empty expression
            if key == .divide || key == .times {
                print("can't add * or /")
                return false
            }
            
            return true
        }
        
        return true
    }
    
    private func canReplaceLast(_ key: CalculatorKey) -> Bool {
        
        if let last = keys.last {
            return key.isOperator && last.isOperator
        }
        return false
    }
}
