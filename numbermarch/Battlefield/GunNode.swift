//
//  GunNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 25/05/22.
//

import Foundation

class GunNode: DigitalCharacterNode {
    
    /**
     Increments the gun's aim
     */
    public func aim() -> Int {
        if self.value > 9 {
            self.value = 0
        } else {
            self.value += 1
        }
        print(self.value)
        return self.value
    }

}
