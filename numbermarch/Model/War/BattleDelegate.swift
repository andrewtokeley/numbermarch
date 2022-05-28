//
//  BattleDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/05/22.
//

import Foundation

/**
 Delegate to let implementations know of significant battle events, like when enemies die or are added to the battlefield.
 */
protocol BattleDelegate {
    
    /**
     Implement this method to be notified whenever an enemy has been killed
     
     - Parameters:
        - battle: battle instance in which the enemy was killed
        - enemy: Enemy instance killed
        - index: index of the enemy killed
     */
    func battle(_ battle: Battle, killedEnemy: Enemy, index: Int)
    
    /**
     Implement this method to be notified when a shot was fired but missed its target
     
     - Parameters:
        - battle: battle instance in which the enemy was killed
        - shotMissedWithValue: the value of the gun shot
     
     */
    func battle(_ battle: Battle, shotMissedWithValue: Int)
    
    /**
     Implement this method to be notified when all enemies have been killed, indicates you've won the battle!
     
     - Parameters:
        - battle: battle instance in which the enemy was killed
     
     */
    func battleAllEnemiesKilled(_ battle: Battle)
    
    /**
     Implement this method to let the ``Battle`` know whether to add a mothership
     
     Different war rules will dictate when a mothership should spawn. Rules are sent to the War instance that is responsible for creating the battles.
     
     - Parameters:
        - battle: battle instance in which the enemy was killed
        - shouldSpawnMotheshipAfterKillOfValue: value of the last enemy killed
     */
    func battle(_ battle: Battle, shouldSpawnMotheshipAfterKillOfValue value: Int) -> Bool
    
    /**
     Called when the battle is lost
     */
    func battleLost()
}
