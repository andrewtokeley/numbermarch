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
    //func battle(_ battle: Battle, newEnemy enemy: Enemy)
    func battle(_ battle: Battle, killedEnemy enemy: Enemy, distance: CGFloat)
    func battle(_ battle: Battle, shotMissedWithValue: Int)
    func battleAllEnemiesKilled(_ battle: Battle)
    func battle(_ battle: Battle, shouldSpawnMotheshipAfterKillOfValue value: Int) -> Bool
}
