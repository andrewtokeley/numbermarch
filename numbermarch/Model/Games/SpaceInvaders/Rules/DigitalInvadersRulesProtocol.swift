//
//  BattleRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/05/22.
//

import Foundation

/**
 Rules of the game
 
 Terminology
 
 - War: represents a series of battles
 - Battle: a battle contains a number of enemies marching towards you. Kill them all and you move to the next battle.
 - Level: a level refers to how many battles you have fought in the war
 
 */
protocol DigitalInvadersRulesProtocol {
    
    /**
    Returns the number of points for killing an enemy at the given position/level.
     
     - Parameters:
        - enemy: Enemy that was shot
        - level: the level when the enemy was shot
        - postion: the position (1 based ) when the enemy was shot
     */
    func pointsForKillingEnemy(enemy: Enemy, level: Int, position: Int) -> Int
    
    /**
     How many seconds does each step of an enemy take.
    */
    func stepTimeInterval(level: Int) -> TimeInterval
    
    /**
     The maximum number of seconds between advancing enemy steps (i.e. what's the slowest they'll advance)
     */
    var maxAvanceSeconds: CGFloat { get }
    
    /**
     The minimum number of seconds between advancing enemy steps (i.e. what's the fastest they'll advance)
     */
    var minAvanceSeconds: CGFloat { get }
    
    /**
     The number of enemies for each level
     */
    func numberOfEnemiesAtLevel(level: Int) -> Int
    
    /**
     The number of shots you have to kill all the enemies in the level. 
     */
    func numberOfShotsAtLevel(level: Int) -> Int
    
    /**
     The number of spaces given to advancing enemies. The more spaces, the more time you have to shoot the enemies. For example, a rule could decide that as levels increase the number of spaces reduces.
     */
    func numberOfSpacesForEnemies(level: Int) -> Int
    
    /**
     Determines how many levels there are before you win the war
     */
    var numberOfLevels: Int { get }
    
    /**
     Returns how many lives you have at the beginning of the game
     */
    var numberOfLives: Int { get }
    
    /**
     Returns whether you should get an extra life at the end of a given level
     */
    func shouldGetExtraLife(level: Int) -> Bool
    
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




