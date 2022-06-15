//
//  EightBomb.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

class EightBomb {
    var exploded: Bool = false
    var position: Int = 0
    
    init(exploded: Bool, position: Int) {
        self.exploded = exploded
        self.position = position
    }
}
