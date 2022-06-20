//
//  EightAttackRulesProtocol.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 18/06/22.
//

import Foundation

/**
 Implementations of this protocol determine the core rules of the 8-Attack game.
 
 Terminology
    - Bomb - the dots on the screen that are exploded when you complete an eight next to them
    - Enemy - the incomplete 8 characters moving across the screen
    - Level - a level last for as long as it takes to explode all the bombs. When all bombs have been exploded the next level begins.
 */
protocol EightAttackRules {
    
    var numberOfBombs: Int { get }
    
    /**
     The number of lives you have at the beginning of the game
     */
    var numberOfLives: Int { get }
    
    /**
     Number of levels before the game is won
     */
    var numberOfLevels: Int { get }
    
    /**
     Returns the TimeInterval it takes for an enemy to move one space.
     
     - Parameters:
        - level: level being played
     */
    func speedOfEnemies(level: Int) -> TimeInterval 
    
    /**
     Returns the score for exploding a bomb on a give level and shot distance.
     
     - Parameters:
        - level: the level the explosion occurred in
        - shotDistance: the distance the missile travelled before it hit the enemy/bomb
     */
    func scoreForExplodingBomb(level: Int, shotDistance: Int) -> Int
    
    /**
     Returns whether the advancing enemy should toggle between two shapes shapes.
     */
    func shouldToggleEnemyType(level: Int) -> Bool
    
}
