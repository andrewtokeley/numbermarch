//
//  TwoMult10WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/05/22.
//

import Foundation

class MultModWarRules: BaseWarRules {
    private var cummulativeKillScore: Int = 0
    
    override var warDescription: String {
        return "Mixed Mod War"
    }
    
    override func levelDescription(level: Int) -> String {
        return "Mothership -> Mod \(modGoal(level: level)) == 0"
    }

    private func modGoal(level: Int) -> Int {
        let modGoals: [Int] = [2,3,4,5,6,7,8,9,10,10]
        if (level < (modGoals.count - 1)) {
            return modGoals[level]
        }
        return modGoals[modGoals.count - 1]
    }
    
    override func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        self.cummulativeKillScore += lastKillValue
        let modGoal = self.modGoal(level: level)
        if self.cummulativeKillScore > 0 && self.cummulativeKillScore % modGoal == 0 {
            self.cummulativeKillScore = 0
            return true
        }
        return false
    }
    
    override func clearState() {
        self.cummulativeKillScore = 0
    }
}
