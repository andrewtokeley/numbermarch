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
    
    /**
     Screen to which the game is displayed
     */
    private var screen: ScreenProtocol
    
    init(screen: ScreenProtocol) {
        self.screen = screen
        self.battle = EightBattle(screenSize: self.screen.numberOfCharacters)
        self.battle.delegate = self
        self.gameLoop()
    }
    
    private func gameLoop() {
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) { timer in
            
        }
    }
    
}

extension EightAttack: EightBattleDelegate {
    func battleLost(_ battle: EightBattle) {
        //
    }
    
    func eightBattle(_ battle: EightBattle, addEnemy enemy: EightEnemy, position: Int) {
        //
    }
    
    func eightBattle(_ battle: EightBattle, enemy: EightEnemy, movedPositionFrom from: Int, to: Int) {
        self.screen.display(.space, screenPosition: from)
        self.screen.display(enemy.asDigitalCharacter, screenPosition: to)
    }
    
    func eightBattle(_ battle: EightBattle, enemyKilled enemy: EightEnemy) {
        self.screen.display(.space, screenPosition: enemy.position)
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
        //
    }
    
    func eightBattle(_ battle: EightBattle, removeMissile missile: EightMissile) {
        //
    }
    
    func eightBattle(_ battle: EightBattle, addMissile missile: EightMissile, position: Int) {
        //
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
        return false
    }
    
    func start() {
        //
    }
    
    func stop() {
        //
    }
    
    func pause() {
        //
    }
    
    func resume() {
        //
    }
    
    
}
