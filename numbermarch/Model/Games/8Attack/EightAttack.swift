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
    
    private var ignoreKeyPresses: Bool = true
    
    /**
     Internal flag to advise whether a game is in play or not
     */
    private var gameActive: Bool = false
    
    /**
     Rules of the game
     */
    private var rules: EightAttackRules
    
    /**
     Game's battle logic. A battle is completed when all the bombs are exploded.
     */
    private var battle: EightBattle
    
    private var gameLoopTimeInterval = TimeInterval(0.05)
    private var gameLoopTimer: Timer?
    private var lastEnemyAdvance: Date?
    private var lastMissileAdvance: Date?
    
    private var enemyTimeInterval = TimeInterval(0.5)
    private var missileTimeInterval = TimeInterval(0.2)
    
    
    /**
     Screen to which the game is displayed
     */
    private var screen: ScreenProtocol
    
    init(screen: ScreenProtocol, rules: EightAttackRules) {
        self.rules = rules
        self.screen = screen
        self.screen.clearScreen(includingMessageText: true)
        
        self.battle = EightBattle(screenSize: self.screen.numberOfCharacters, rules: self.rules)
        self.battle.delegate = self
        self.ignoreKeyPresses = true
    }
    
    /**
     Called to start a new game.
     */
    private func startNewGame() {
        self.gameLoopTimer?.invalidate()
        self.gameActive = true
        
        // initialise the game speed
        // TODO
        self.battle.readyToStartGame()
        self.displayLives(self.battle.lives)
    }
    
    /**
     Game loop responsible for advancing and drawing the enemies and missiles
     */
    private func startGameLoop() {
        self.lastEnemyAdvance = Date.now
        self.lastMissileAdvance = Date.now
        
        self.gameLoopTimer = Timer.scheduledTimer(withTimeInterval: self.gameLoopTimeInterval, repeats: true, block: { timer in
            
            let dEnemy = self.lastEnemyAdvance!.distance(to: Date.now)
            let dMissile = self.lastMissileAdvance!.distance(to: Date.now)
            
            let enemyTimeInterval = self.rules.speedOfEnemies(level: self.battle.level)
            let moveEnemy = dEnemy > enemyTimeInterval
            
            let moveMissile = dMissile > self.missileTimeInterval
            
            if moveMissile { self.advanceMissile() }
            if moveEnemy { self.advanceEnemy() }
            
        })
        
    }
    
    private func stopBattle() {
        self.gameActive = false
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
    
    private func displayScore(level: Int, score: Int, completion: (() -> Void)? = nil) {
        self.screen.clearScreen(includingMessageText: false)
        
        // pad out the score with leading zeros to make it exactly 6 characters long
        let scorePadded = String(score).leftPadding(toLength: 6, withPad: "0")
        let levelPadded = String(level).leftPadding(toLength: 2, withPad: " ")
        let message = "\(levelPadded)-\(scorePadded)"
        self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
            completion?()
        }
    }
    
    private func displayLives(_ lives: Int) {
        self.screen.displayTextMessage(text: "LIVES - \(lives)")
    }
}

extension EightAttack: EightBattleDelegate {
    
//    func eightBattle(_ battle: EightBattle, enemyChangedType type: EightEnemyType, position: Int) {
//        self.screen.display(type.asDigitalCharacter, screenPosition: position)
//    }
    
    func eightBattle(_ battle: EightBattle, lostLife livesLeft: Int) {
        
        self.displayLives(self.battle.lives)
        self.displayScore(level: self.battle.level, score: self.battle.score) {
            self.screen.clearScreen(includingMessageText: false)
            self.battle.readyToRestartLevel()
        }
    }
    
    func eightBattle(_ battle: EightBattle, gainedLife livesGained: Int) {
        self.displayLives(self.battle.lives)
    }
    
    func battleGameOver(_ battle: EightBattle) {
        self.screen.displayTextMessage(text: "GAME OVER")
        self.stopBattle()
        self.displayScore(level: self.battle.level, score: self.battle.score)
    }
    
    func eightBattle(_ battle: EightBattle, newLevel: Int, score: Int) {
        
        self.ignoreKeyPresses = true
        self.gameLoopTimer?.invalidate()
        self.displayScore(level: self.battle.level, score: self.battle.score) {
            self.screen.clearScreen(includingMessageText: false)
            self.ignoreKeyPresses = false
            self.battle.readyForNextLevel()
            self.startGameLoop()
        }
    }
    
    func battleWon(_ battle: EightBattle) {
        self.screen.displayTextMessage(text: "YOU WON!")
        self.gameActive = false
        self.displayScore(level: self.battle.level, score: self.battle.score)
    }
    
    func eightBattle(_ battle: EightBattle, removeEnemy enemy: EightEnemy) {
        self.screen.display(.space, screenPosition: enemy.position)
    }
    
    func eightBattle(_ battle: EightBattle, addEnemy enemy: EightEnemy, position: Int) {
        self.lastEnemyAdvance = Date.now
        self.screen.display(enemy.type.asDigitalCharacter, screenPosition: position)
    }
    
    func eightBattle(_ battle: EightBattle, enemy: EightEnemy, movedPositionFrom from: Int, to: Int) {
        self.screen.display(.space, screenPosition: from)
        self.screen.display(enemy.type.asDigitalCharacter, screenPosition: to)
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
    
    var showScreenCellBorders: Bool {
        return false
    }
    
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
        self.startNewGame()
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
        guard !self.ignoreKeyPresses else { return }
        
        if key == .point {
            self.fire(.top)
        } else if key == .equals {
            self.fire(.middle)
        } else if key == .plus {
            self.fire(.bottom)
        }
    }
    
    
}
