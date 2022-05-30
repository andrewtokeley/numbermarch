//
//  DefaultBattleRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 29/05/22.
//

import Foundation

/**
 Do I need this?
 */
class DefaultBattleRules: BattleRulesProtocol {
    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int {
        return enemy.value
    }
    
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        return false
    }
    
    func clearState() {
        //
    }
    
    
}
