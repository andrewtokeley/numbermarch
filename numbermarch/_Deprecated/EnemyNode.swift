//
//  EnemyNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 21/05/22.
//

import Foundation

class EnemyNode {
    var numberNode: NumberNode
    var enemy: Enemy
    
    init(numberNode: NumberNode, enemy: Enemy) {
        self.numberNode = numberNode
        self.enemy = enemy
    }
}
