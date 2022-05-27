//
//  Enemy.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/05/22.
//

import Foundation

/**
 Structure that represents an enemy
 */
struct Enemy: Equatable {
    
    public let id: String = UUID().uuidString
    
    /// The value of an enemy, if the enemy is a mothership it's value will be zero
    var value: Int
    
    /// Type of enemy
    var type: EnemyType {
        return value == 0 ? .Mothership : .Soldier
    }
    
    /// The status of the enemy.
    var status: EnemyStatus = .Ready
    
}

/**
 Status of the enemy, alive, dead or ready to battle!
 */
enum EnemyStatus {
    /// Enemy is engaged on the battlefield and still alive
    case Alive
    /// Enemy is on the battlefield but dead
    case Dead
    /// Enemy is ready to come on the battlefield
    case Ready
}

enum EnemyType {
    /// Regular soldier
    case Soldier
    /// Mothership, extra points for killing
    case Mothership
}
