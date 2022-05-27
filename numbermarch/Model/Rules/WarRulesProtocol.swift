//
//  BattleRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/05/22.
//

import Foundation

protocol WarRulesProtocol {
    
    var warDescription: String { get }
    func levelDescription(level: Int) -> String
    
    func stepTimeInterval(level: Int) -> TimeInterval
    func numberOfEnemiesAtLevel(level: Int) -> Int
    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int
    
    /**
    Calculates whether after killing an enemy of a certain value a mothership should be spawned.
     */
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool
  
    var numberOfLevels: Int { get }
    var numberOfLives: Int { get }
    
    /**
     Clear any internal state, typically called before sharing this rule instance for another battle
     
     Implementors of this delegate method should reset any state properties if it shouldn't be shared across multiple battles
     */
    func clearState()
    
}




