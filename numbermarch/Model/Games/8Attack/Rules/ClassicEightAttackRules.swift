//
//  ClassicEightAttackRules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 18/06/22.
//

import Foundation

/**
The rules for the classic 1980's version of the game as played on the Casio MG-775 and MG-885 calculators
 
 Actually never played the game but here are the rules I could glean from the internet :-)
 
 - Level 1, slowest speed, simply shoot correct missiles to complete the 8. Or any missile to hit magic H shape.
 - Level 2-3 - same as Stage 1 but faster
 - Level 4 - the missing segment alternates as the 8 moves across the screen
 - Level 5 - your missile changes it's trajectory as it moves
 
 If you're careful you can ensure a special H shape appears (worth 100 points) but making the corresponding postions of the bombs you explode add up to 10!
 
 */
class ClassicEightAttackRules: EightAttackRules {
    
    var numberOfBombs: Int = 8
    
    var numberOfLives: Int = 3
    
    var numberOfLevels: Int = 5
    
    func speedOfEnemies(level: Int) -> TimeInterval {
        
        var time: TimeInterval = TimeInterval(0.6)
        
        // speed things up on levels 2 and 3
        if level.isBetween(2, 3, true) { time = TimeInterval(0.4) }

        return time
    }
    
    func scoreForExplodingBomb(level: Int, shotDistance: Int) -> Int {
        // get more points the further away the enemy is when you hit it
        return shotDistance * 10
    }
    
    func shouldToggleEnemyType(level: Int) -> Bool {
        return level == 4
    }
    
}
