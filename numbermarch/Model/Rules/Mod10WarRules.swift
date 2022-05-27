//
//  Mod10WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/05/22.
//

import Foundation

class Mod10WarRules: BaseWarRules {
    
    private var cummulativeKillScore: Int = 0
    
    override var warDescription: String {
        return "Mod 10 War"
    }
    
    override func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        self.cummulativeKillScore += lastKillValue
        if self.cummulativeKillScore > 0 && self.cummulativeKillScore % 10 == 0 {
            self.cummulativeKillScore = 0
            return true
        }
        return false
    }
    
    override func clearState() {
        self.cummulativeKillScore = 0
    }
}
