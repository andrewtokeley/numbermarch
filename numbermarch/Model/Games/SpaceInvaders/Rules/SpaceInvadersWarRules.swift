//
//  Mod10WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/05/22.
//

import Foundation

class SpaceInvadersWarRules: WarRulesProtocol {
    
    private var cummulativeKillScore: Int = 0
    
    func pointsForKillingEnemy(enemy: Enemy, level: Int, position: Int) -> Int {
        if enemy.type == .Mothership {
            return 300
        } else {
            if level < 10 && position <= 6 {
                return [10,20,30,40,50,60][position-1]
            } else if level <= self.numberOfLevels && position <= 5 {
                return [20,40,60,80,100][position-1]
            } else {
                return 0
            }
        }
    }
    
    func numberOfSpacesForEnemies(level: Int) -> Int {
        if level <= 9 {
            return 6
        }
        return 5
    }
    
    func shouldGetExtraLife(level: Int) -> Bool {
        return level > 9 && (level-1) % 9 == 0
    }
    
    func stepTimeInterval(level: Int) -> TimeInterval {
        guard level <= self.numberOfLevels else {
            // should never happen but return the fastest if it does!
            return 0.2
        }
        let speeds = [1.6, 1.3, 1.1, 1.0, 0.9, 0.8, 0.7, 0.5, 0.4]
        let index = level < 10 ? level-1 : 18-level-1
        return TimeInterval(speeds[index])
    }
    
    func numberOfEnemiesAtLevel(level: Int) -> Int {
        return 16
    }
    
    func numberOfShotsAtLevel(level: Int) -> Int {
        return 30
    }
    
    var numberOfLevels: Int {
        return 18
    }
    
    var numberOfLives: Int {
        return 3
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
    
    
    func clearState() {
        self.cummulativeKillScore = 0
    }
}
