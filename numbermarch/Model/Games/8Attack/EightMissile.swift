//
//  EightMissile.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/06/22.
//

import Foundation

class EightMissile {
    var type: EightMissilleTypeEnum
    var position: Int
    var direction: EightDirection
    
    init(type: EightMissilleTypeEnum, position: Int, direction: EightDirection) {
        self.type = type
        self.position = position
        self.direction = direction
    }
}
