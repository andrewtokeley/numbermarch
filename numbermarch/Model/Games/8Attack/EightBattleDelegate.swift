//
//  EightBattleDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

protocol EightBattleDelegate {
    func eightBattle(_ battle: EightBattle, addEnemy enemy: EightEnemy, position: Int)
    func eightBattle(_ battle: EightBattle, enemy: EightEnemy, movedPositionFrom from: Int, to: Int)
    func eightBattle(_ battle: EightBattle, enemyKilled enemy: EightEnemy)
    func eightBattle(_ battle: EightBattle, removeEnemy enemy: EightEnemy)
    
    func eightBattle(_ battle: EightBattle, bombsCreated bombs: [EightBomb])
    func eightBattle(_ battle: EightBattle, bombExploded bomb: EightBomb)
    
    func eightBattle(_ battle: EightBattle, addMissile missile: EightMissile, position: Int)
    func eightBattle(_ battle: EightBattle, missile: EightMissile, movedPositionFrom from: Int, to: Int)
    func eightBattle(_ battle: EightBattle, removeMissile missile: EightMissile)
    
    func eightBattle(_ battle: EightBattle, lostLife livesLeft: Int)
    func eightBattle(_ battle: EightBattle, gainedLife livesGained: Int)
    
    func battleGameOver(_ battle: EightBattle)
    func battleWon(_ battle: EightBattle)

    func eightBattle(_ battle: EightBattle, newLevel: Int, score: Int)
}
