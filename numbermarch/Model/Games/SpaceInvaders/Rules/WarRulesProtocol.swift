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
protocol WarRulesProtocol {
    
    /**
     How many seconds does each step of an enemy take
     */
    func stepTimeInterval(level: Int) -> TimeInterval
    
    /**
     The number of enemies for each level
     */
    func numberOfEnemiesAtLevel(level: Int) -> Int
    
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
    
}




