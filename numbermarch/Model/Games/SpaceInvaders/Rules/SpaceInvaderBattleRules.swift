//
//  SpaceInvaderBattleRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 29/05/22.
//

import Foundation

class SpaceInvaderBattleRules: BattleRulesProtocol {
    
    private var cummulativeKillScore: Int = 0

    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int {
        return enemy.type == .Mothership ? 100 : enemy.value
    }
    
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        if let character = DigitalCharacter(rawValue: lastKillValue) {
            if character != .mothership {
                self.cummulativeKillScore += lastKillValue
                if self.cummulativeKillScore > 0 && self.cummulativeKillScore % 10 == 0 {
                    self.cummulativeKillScore = 0
                    return true
                }
            }
        }
        return false
    }
    
    
    /**
     Clear any internal state, typically called before sharing this rule instance for another battle
     
     Implementors of this delegate method should reset any state properties if it shouldn't be shared across multiple battles
     */
    func clearState() {
        self.cummulativeKillScore = 0
    }
    
   

}
