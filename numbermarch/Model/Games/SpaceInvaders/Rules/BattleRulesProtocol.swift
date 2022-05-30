//
//  BattleRulesProtocol.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 29/05/22.
//

import Foundation

protocol BattleRulesProtocol {
    
    /**
     Returns the number of points you earned for killing the enemy in the battle at a given level
     */
    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int
    
    /**
    Calculates whether after killing an enemy of a certain value a mothership should be spawned.
     */
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool
    
    
    /**
     Clear any internal state, typically called before sharing this rule instance for another battle
     
     Implementors of this delegate method should reset any state properties if it shouldn't be shared across multiple battles
     */
    func clearState()
    
}
