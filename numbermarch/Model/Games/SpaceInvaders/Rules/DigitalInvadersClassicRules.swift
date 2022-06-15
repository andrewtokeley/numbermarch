//
//  Mod10WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/05/22.
//

import Foundation

class DigitalInvadersClassicRules: DigitalInvadersRulesProtocol {
    
    private var cummulativeKillScore: Int = 0
    
    var maxAvanceSeconds: CGFloat {
        return 1.5
    }
    
    var minAvanceSeconds: CGFloat {
        return 0.4
    }
    
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
        guard level >= 1 && level <= self.numberOfLevels else {
            // should never happen but return the fastest if it does!
            return 0.2
        }
        
        let step = (maxAvanceSeconds - minAvanceSeconds)/CGFloat(self.numberOfLevels/2 - 1)
        var speeds = [CGFloat]()
        var incrememnt = self.maxAvanceSeconds
        for _ in 0...(self.numberOfLevels/2 - 1) {
            speeds.append(incrememnt)
            incrememnt -= step
        }
        // first half of all levels will get these speeds respectively, the second half will get the same values
        let index = level <= (self.numberOfLevels/2) ? level-1 : level - (self.numberOfLevels)/2 - 1
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
