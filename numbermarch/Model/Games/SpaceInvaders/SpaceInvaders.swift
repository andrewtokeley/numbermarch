//
//  SpaceInvaders.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

class SpaceInvaders {
    
    private var screen: ScreenProtocol
    private var war: War?
    private var rules: WarRulesProtocol
    private var score: Int = 0
    private var lives: Int = 0
    private var battle: Battle?
    private var service: WarServiceInterface?
    
    private var killTimer: Timer?
    
    private var stopAdvance: Bool = false
    
    private var timeInterval: TimeInterval {
        return self.rules.stepTimeInterval(level: self.war?.level ?? 1)
    }
    
    init(screen: ScreenProtocol) {
        self.screen = screen
        self.rules = Mod10WarRules()
    }
    
    private func newGame() {
        self.stopAdvance = true
        let service = WarFactory.sharedInstance.warService
        service.createWar(rules: self.rules, completion: { war, error in
            self.war = war
            self.lives = self.rules.numberOfLives
            self.score = 0
            self.battle = self.war?.moveToNextBattle()
            self.battle?.delegate = self
            //self.screen.freezeCharacters(screenPosition: 3)
            
            self.screen.clearScreen()
            
            // TODO: display high score
            self.displayHighScore() {
                self.play()
            }
        })
    }
    
    private func playNextBattle() {
        self.battle = self.war?.moveToNextBattle()
        self.battle?.delegate = self
        self.war?.rules.clearState()
        self.play()
    }
    
    private func play() {
        self.stopAdvance = false // just in case?
        self.screen.clearScreen()
        self.screen.display(.one, screenPosition: 2)
        self.displayLives(lives: self.lives)
        
        self.advanceEnemies()
    }
    
    private func aim() {
        // increment the gun value
        var value = self.screen.characterAt(2).rawValue
        if value > 9 {
            value = 0
        } else {
            value += 1
        }
        if let character = DisplayCharacter(rawValue: value) {
            self.screen.display(character, screenPosition: 2)
        }
    }
    
    private func displayLives(lives: Int) {
        var character: DisplayCharacter = .threebars
        if lives == 2 { character = .twobars }
        else if lives == 1 { character = .onebar }
        self.screen.display(character, screenPosition: 3)
    }
    
    private func handleKill() {
        // halt the march!
        self.stopAdvance = true

        // refresh the display to remove killed enemy
        self.displayEnemies()
        
        // reset the time to wait post kill
        self.killTimer?.invalidate()
        self.killTimer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: false) { (timer) in
            // restart
            self.stopAdvance = false
            self.advanceEnemies()
        }
    }
    
    private func handleGameOver() {
        self.screen.clearScreen()
        self.displayScore()
        self.screen.displayTextMessage(text: "GAME OVER")
    }
    
    private func displayHighScore(completion: (() -> Void)? = nil) {
        
        let highscore: Int = 16430
        
        let message = String(highscore).leftPadding(toLength: 6, withPad: "0")
        self.screen.clearScreen()
        self.screen.displayTextMessage(text: "HIGH SCORE")
        self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
            completion?()
        }
    }
    
    private func displayScore(completion: (() -> Void)? = nil) {
        if let level = self.war?.level {
            
            // pad out the score with leading zeros to make it exactly 6 characters long
            let scoreAsString = String(self.score).leftPadding(toLength: 6, withPad: "0")
            let message = "\(level)-\(scoreAsString)"
            self.screen.clearScreen()
            self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    private func shoot() {
        // get the value of the gun
        let value = self.screen.characterAt(2).rawValue
        self.battle?.shoot(value: value)
    }
    
    private func advanceEnemies() {
        guard !stopAdvance else { return }
        
        if let canAdvance = self.battle?.advanceEnemies() {
            if canAdvance {
                self.displayEnemies(delay: self.timeInterval) {
                    self.advanceEnemies()
                }
            }
        }
    }
    
    private func displayEnemies(delay: TimeInterval = TimeInterval(0), completion: (() -> Void)? = nil) {
        if let characters = self.battle?.battlefield.map( { ($0 != nil) ? DisplayCharacter(rawValue: $0!.value ) ?? .space : .space }) {
            self.screen.display(characters, screenPosition: self.screen.numberOfCharacters)
        }
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
}

extension SpaceInvaders: KeyboardDelegate {
    func keyPressed(key: CalculatorKey) {
        if key == .game {
            // Start new game
            self.newGame()
        } else if key == .point {
            self.aim()
        } else if key == .plus {
            // shoot
            self.shoot()
        }
    }
    
}

extension SpaceInvaders: BattleDelegate {
    func battleLost() {
        self.lives -= 1
        if self.lives == 0 {
            self.handleGameOver()
        } else {
            // restart battle
            self.displayScore() {
                self.battle?.takeEnemiesOffBattlefield()
                self.war?.rules.clearState()
                self.play()
            }
        }
    }
    
    func battle(_ battle: Battle, killedEnemy enemy: Enemy, index: Int) {
        if let level = self.war?.level {
            self.score += self.rules.pointsForKillingEnemy(enemy: enemy, level: level)
        }
        self.handleKill()
    }
    
    func battle(_ battle: Battle, shotMissedWithValue: Int) {
        // do nothing for now
    }
    
    func battleAllEnemiesKilled(_ battle: Battle) {
        self.displayScore() {
            self.playNextBattle()
        }
    }
    
    func battle(_ battle: Battle, shouldSpawnMotheshipAfterKillOfValue value: Int) -> Bool {
        if let level = self.war?.level {
            return self.war?.rules.shouldSpawnMothership(lastKillValue: value, level: level) ?? false
        }
        return false
    }
}

extension SpaceInvaders: GamesProtocol {
    
    func start() {
        self.newGame()
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
