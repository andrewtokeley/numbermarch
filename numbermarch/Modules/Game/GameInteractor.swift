//
//  GameInteractor.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//
//

import Foundation

class GameInteractor: Interactor {
    
    private var war: War!
    private var rules: WarRulesProtocol!
    private var score: Int = 0
    private var lives: Int = 2
    
    // MARK: - Presenter calls
    
    public func initialiseNewWar() {
        let service = WarFactory.sharedInstance.warService
        self.rules = Mod10WarRules()
        
        self.presenter.displayWarDescription(description: self.rules.warDescription)
        
        service.createWar(rules: rules, completion: { war, error in
            self.war = war
            self.lives = self.rules.numberOfLives
            self.score = 0
            self.presenter.didUpdateScore(score: self.score)
            self.presenter.didUpdateLives(lives: self.lives)
            self.presenter.didUpdateLevel(level: self.war.level)
            self.presenter.didUpdateGunValue(value: 1)
            self.startNextBattle()
        })
    }
    
    public func startNextBattle() {
        self.rules.clearState()
        if let battle = war.moveToNextBattle() {
            self.presenter.displayLevelDescription(description: self.rules.levelDescription(level: war.level))
            self.presenter.startNewBattle(battle: battle, level: war.level, stepTimeInterval: rules.stepTimeInterval(level: war.level))
        } else {
            self.presenter.didWinWar()
        }
    }
    
    /**
     Called when the enemies defeated the player. If enough lives left, the enemies will be pushed back and the battle will be restarted
     */
    public func didLoseBattle() {
        self.lives -= 1
        if self.lives == 0 {
            self.presenter.gameOver()
        } else {
            self.presenter.didUpdateLives(lives: self.lives)
            self.presenter.restartBattle()
        }
    }
    
    public func didKillEnemy(enemy: Enemy, distance: CGFloat) {
        // TODO: supply distance to rule calc
        self.score += self.rules.pointsForKillingEnemy(enemy: enemy, level: war.level)
        presenter.didUpdateScore(score: score)
    }
    
    public func didKillAllEnemies() {
        self.startNextBattle()
    }
    
    public func shouldSpawnMotheship(value: Int) -> Bool {
        return rules.shouldSpawnMothership(lastKillValue: value, level: self.war.level)
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GameInteractor {
    var presenter: GamePresenter {
        return _presenter as! GamePresenter
    }
}
