//
//  GamePresenter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//
//

import Foundation

class GamePresenter: Presenter {
    
    private var battle: Battle?
    private var playerValue: Int = 0
    
    //private var numberOfLevels: Int = 0
    
//    private var score: Int = 0 {
//        didSet {
//            view.displayScore(score: score)
//        }
//    }
//
//    private var level: Int = 1 {
//        didSet {
//            view.displayLevel(level: level)
//        }
//    }
    
    //private var speed: CGFloat = 0
    
    override func viewHasLoaded() {
        
    }
    
    /**
     Called by the view when it's animated an enemy onto the battlefield and is ready for another to be added
     */
    public func readyForNextEnemy() {
        // bring another enemy onto the battlefield
        let _ = self.battle?.addNextEnemyToBattle()
    }
    
    public func didSelectNewGame() {
        view.displayMessage(message: "New Game")
        interactor.initialiseNewWar()
    }
    
    public func enemiesWon() {
        interactor.didLoseBattle()
    }
    
    
    /**
     Iinitialise the pesenter for a new war
     */
//    public func prepareForWar(speed: CGFloat) {
//        view.displayScore(score: 0)
//        view.displayLevel(level: 0)
//        view.displayLives(lives: 3)
//        view.setPlayerValue(value: 1)
//    }
    
    public func restartBattle() {
        self.battle?.takeEnemiesOffBattlefield()
        view.prepareBattlefield() {
        
        }
    }
    
    /**
     Called by interactor when a new battle is ready to start
     */
    public func startNewBattle(battle: Battle, level: Int, stepTimeInterval: TimeInterval) {
        
        self.battle = battle
        self.battle?.delegate = self
        
        view.displayLevel(level: level)
        view.setBattlefieldSpeed(stepTimeInterval: stepTimeInterval)
        view.prepareBattlefield() {
            self.view.advanceEnemies()
        }
    }
    
    public func didUpdateGunValue(value: Int) {
        //self.playerValue = value
        view.setGunValue(value: value)
    }
    
    public func didUpdateLives(lives: Int) {
        view.displayLives(lives: lives)
    }
    
    public func didUpdateLevel(level: Int) {
        view.displayLevel(level: level)
    }
    
    public func didUpdateScore(score: Int) {
        view.displayScore(score: score)
    }
    
    public func didAim() {
        self.playerValue += 1;
        if self.playerValue >= 12 {
            self.playerValue = 0
        }
        view.setGunValue(value: self.playerValue)
    }
    
    public func didShoot(value: Int) {
        self.battle?.shoot(value: value)
    }
    
    public func gameOver() {
        view.displayMessage(message: "GAME OVER!")
        view.prepareBattlefield {
            //
        }
    }
    
    public func didWinWar() {
        view.displayMessage(message: "YOU WON!")
    }
    
    public func displayWarDescription(description: String) {
        view.displayWarDescription(description: description)
    }
    
    public func displayLevelDescription(description: String) {
        view.displayLevelDescription(description: description)
    }
    
    public func getNextEnemy() -> Enemy? {
        return self.battle?.addNextEnemyToBattle()
    }
}

extension GamePresenter: BattleDelegate {

    func battle(_ battle: Battle, shouldSpawnMotheshipAfterKillOfValue value: Int) -> Bool {
        return interactor.shouldSpawnMotheship(value: value)
    }
    
    func battle(_ battle: Battle, killedEnemy enemy: Enemy, distance: CGFloat) {
        view.killEnemy(enemy: enemy)
        interactor.didKillEnemy(enemy: enemy, distance: distance)
    }
    
//    func battle(_ battle: Battle, newEnemy enemy: Enemy) {
//        //view.displayNewEnemy(enemy: enemy)
//    }
    
    func battle(_ battle: Battle, shotMissedWithValue: Int) {
        //
        print("missed \(shotMissedWithValue)")
    }
    
    func battleAllEnemiesKilled(_ battle: Battle) {
        interactor.didKillAllEnemies()
    }
    
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GamePresenter {
    var view: GameViewInterface {
        return _view as! GameViewInterface
    }
    var interactor: GameInteractor {
        return _interactor as! GameInteractor
    }
    var router: GameRouter {
        return _router as! GameRouter
    }
}
