//
//  Int.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/06/22.
//

import Foundation

extension Int {
    /**
     Returns whether the integer is between the values provided.
     
     - Parameters:
        - from: lower bound
        - to: upper bound
        - inclusive: whether a value that is equal to a bound is considered in between. Default is false
     
     By default, the comparison is exclusive of the boundaries, for example,
     
     ```
     let x = 2
     let result = x.isBetween(2, 5)
     // result will be false
     ```
     
     This can be overriden;;
     
     ```
     let x = 2
     let result = x.isBetween(2, 5, true)
     // result will be true
     ```
     
     */
    func isBetween(_ from: Int, _ to: Int, _ inclusive: Bool = false) -> Bool {
        if inclusive {
            return self >= from && self <= to
        } else {
            return self > from && self < to
        }
    }
    
    
}
