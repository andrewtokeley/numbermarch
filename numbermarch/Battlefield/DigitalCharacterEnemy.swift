//
//  EnemyNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation
import SpriteKit

class DigitalCharacterEnemy: EnemyNode {
    
    init(enemy: Enemy) {
        let node = DigitalCharacterNode(value: enemy.value)
        super.init(numberNode: node, enemy: enemy)
    }

}
