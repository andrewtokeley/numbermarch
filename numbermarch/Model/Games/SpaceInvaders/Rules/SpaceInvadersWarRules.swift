//
//  Mod10WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/05/22.
//

import Foundation

class SpaceInvadersWarRules: WarRulesProtocol {
    
    func numberOfSpacesForEnemies(level: Int) -> Int {
        if level < 10 {
            return 6
        }
        return 5
    }
    
    func shouldGetExtraLife(level: Int) -> Bool {
        return level == 10
    }
    
    func stepTimeInterval(level: Int) -> TimeInterval {
        let seconds = CGFloat(numberOfLevels - level + 1) * 0.1
        return TimeInterval(seconds)
    }
    
    func numberOfEnemiesAtLevel(level: Int) -> Int {
        return 16
    }
    
    var numberOfLevels: Int {
        return 18
    }
    
    var numberOfLives: Int {
        return 3
    }
    
}
