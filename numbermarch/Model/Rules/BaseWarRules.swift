//
//  WarRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/05/22.
//

import Foundation

class BaseWarRules: WarRulesProtocol {
    
    var warDescription: String {
        return "Kill all the enemies by matching their value and firing"
    }
    
    func levelDescription(level: Int) -> String {
        return ""
    }
    
    
    func stepTimeInterval(level: Int) -> TimeInterval {
        let seconds = CGFloat(numberOfLevels - level + 1) * 0.1
        return TimeInterval(seconds)
    }
    
    func numberOfEnemiesAtLevel(level: Int) -> Int {
        return 10
    }
    
    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int {
        return enemy.type == .Mothership ? 100 : enemy.value
    }
    
    var numberOfLevels: Int {
        return 10
    }
    
    var numberOfLives: Int {
        return 3
    }
    
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        return false
    }
    
    func clearState() {
    }
}
