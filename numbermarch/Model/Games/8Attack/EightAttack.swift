//
//  8Attack.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

/**
 Classic Casio MG-885 8-Attack Game
 */
class EightAttack {
    
    /**
     Internal flag to advise whether a game is in play or not
     */
    private var gameActive: Bool = false
    
    /**
     Game's battle logic. A battle is completed when all the bombs are exploded.
     */
    private var battle: EightBattle
    
    private var gameLoopTimeInterval = TimeInterval(0.05)
    private var gameLoopTimer: Timer?
    private var lastEnemyAdvance: Date?
    private var lastMissileAdvance: Date?
    
    private var enemyTimeInterval = TimeInterval(0.3)
    private var missileTimeInterval = TimeInterval(0.2)
    
    
    /**
     Screen to which the game is displayed
     */
    private var screen: ScreenProtocol
    
    init(screen: ScreenProtocol) {
        self.screen = screen
        self.screen.clearScreen(includingMessageText: true)
        
        self.battle = EightBattle(screenSize: self.screen.numberOfCharacters)
        self.battle.delegate = self
    }
    
    private func startNewBattle() {
        self.gameActive = true
        self.battle.readyForNewBattle()
        self.battle.readyForNextEnemy()
        self.startGameLoop()
    }
    
    private func startGameLoop() {
        self.lastEnemyAdvance = Date.now
        self.lastMissileAdvance = Date.now
        
        print("create Timer")
        self.gameLoopTimer = Timer.scheduledTimer(withTimeInterval: self.gameLoopTimeInterval, repeats: true, block: { timer in
            
            let dEnemy = self.lastEnemyAdvance!.distance(to: Date.now)
            let dMissile = self.lastMissileAdvance!.distance(to: Date.now)
            
            let moveEnemy = dEnemy > self.enemyTimeInterval
            let moveMissile = dMissile > self.missileTimeInterval
            
            if moveEnemy { self.advanceEnemy() }
            if moveMissile { self.advanceMissile() }
        })
        
    }
    
    private func stopBattle() {
        self.gameLoopTimer?.invalidate()
    }
    
    private func pauseBattle() {
        self.screen.displayTextMessage(text: "PAUSED")
        self.gameLoopTimer?.invalidate()
        self.gameLoopTimer = nil
    }
    
    private func resumeBattle() {
        self.screen.displayTextMessage(text: "")
        self.startGameLoop()
    }
    
    private func advanceEnemy() {
        self.lastEnemyAdvance = Date.now
        let _ = self.battle.advanceEnemy()
    }
    
    private func advanceMissile() {
        self.lastMissileAdvance = Date.now
        let _ = self.battle.advanceMissile()
    }
    
    private func fire(_ missileType: EightMissilleTypeEnum) {
        // can't fire if another missile is around
        guard battle.missile == nil else { return }
        
        battle.addMissile(type: missileType)
    }
}

extension EightAttack: EightBattleDelegate {
    
    func battleWon(_ battle: EightBattle) {
        self.screen.displayTextMessage(text: "YOU WON!")
        self.gameActive = false
    }
    
    func eightBattle(_ battle: EightBattle, removeEnemy enemy: EightEnemy) {
        self.screen.display(.space, screenPosition: enemy.position)
    }
    
    func battleLost(_ battle: EightBattle) {
        self.screen.displayTextMessage(text: "BATTLE LOST")
        self.gameActive = false
    }
    
    func eightBattle(_ battle: EightBattle, addEnemy enemy: EightEnemy, position: Int) {
        self.lastEnemyAdvance = Date.now
        self.screen.display(enemy.asDigitalCharacter, screenPosition: position)
    }
    
    func eightBattle(_ battle: EightBattle, enemy: EightEnemy, movedPositionFrom from: Int, to: Int) {
        self.screen.display(.space, screenPosition: from)
        self.screen.display(enemy.asDigitalCharacter, screenPosition: to)
    }
    
    func eightBattle(_ battle: EightBattle, enemyKilled enemy: EightEnemy) {

        // display an eight
        self.screen.display(.eight, screenPosition: enemy.position)
        
        // Wait a step, remove, then get ready for next enemy
        let _ = Timer.scheduledTimer(withTimeInterval: self.enemyTimeInterval, repeats: false) { timer in
            self.screen.display(.space, screenPosition: enemy.position)
            self.battle.readyForNextEnemy()
        }
        
    }
    
    func eightBattle(_ battle: EightBattle, bombsCreated bombs: [EightBomb]) {
        bombs.forEach({ bomb in
            if bomb.exploded {
                self.screen.removeDecimalPoint(bomb.position)
            } else {
                self.screen.displayDecimalPoint(bomb.position, makeUnique: false)
            }
        })
    }
    
    func eightBattle(_ battle: EightBattle, bombExploded bomb: EightBomb) {
        self.screen.removeDecimalPoint(bomb.position)
    }
    
    func eightBattle(_ battle: EightBattle, missile: EightMissile, movedPositionFrom from: Int, to: Int) {
        self.screen.display(.space, screenPosition: from)
        self.screen.display(missile.type.asDigitalCharacter, screenPosition: to)
    }
    
    func eightBattle(_ battle: EightBattle, removeMissile missile: EightMissile) {
        self.screen.display(.space, screenPosition: missile.position)
    }
    
    func eightBattle(_ battle: EightBattle, addMissile missile: EightMissile, position: Int) {
        self.lastMissileAdvance = Date.now
        self.screen.display(missile.type.asDigitalCharacter, screenPosition: position)
    }
    
    
}

extension EightAttack: GamesProtocol {
    var name: String {
        return "8 Attack"
    }
    
    var isGameStarted: Bool {
        return self.gameActive
    }
    
    var isPaused: Bool {
        return self.gameLoopTimer == nil
    }
    
    func start() {
        self.startNewBattle()
    }
    
    func stop() {
        self.stopBattle()
    }
    
    func pause() {
        self.pauseBattle()
    }
    
    func resume() {
        self.resumeBattle()
    }
    
    
}

extension EightAttack: KeyboardDelegate {
    func keyPressed(key: CalculatorKey) {
        if key == .point {
            self.fire(.top)
        } else if key == .equals {
            self.fire(.middle)
        } else if key == .plus {
            self.fire(.bottom)
        }
    }
    
    
}
