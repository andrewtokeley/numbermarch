//
//  SpaceInvaders.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

class SpaceInvaders {
    
    // MARK: - Private Properties
    
    /**
     Reference to the screen onto which the game is presented
     */
    private var screen: ScreenProtocol
    
    /**
     Reference to the war instance that represents a series of increasingly fast battle advances
     */
    private var war: War?
    
    /**
     The rules of war
     */
    private var warRules: WarRulesProtocol
    
    /**
     The rules of the battle
     */
    private var battleRules: BattleRulesProtocol
    
    /**
     Reference to the current score
     */
    private var score: Int = 0
    
    /**
     Reference to the number of lives left
     */
    private var lives: Int = 0
    
    /**
    Reference to the battle being fought
     */
    private var battle: Battle?
    
    /**
     The war service used to generate the war
     */
    private var service: WarServiceInterface?
    
    /**
     A time that's used to pause while an enemy is killed
     */
    private var killTimer: Timer?
    
    /**
     Set to stop the game loop from advancing the enemies
     */
    private var stopAdvance: Bool = false
    
    /**
     Set to determine whether to recognise key presses from the calculator. Sometimes it's important for the screen to display information without the user being able to interact with the game.
     */
    private var ignoreKeyPresses: Bool = false
    
    /**
     The TimeInterval that represents how long each game step takes
     */
    private var timeInterval: TimeInterval {
        return self.warRules.stepTimeInterval(level: self.war?.level ?? 1)
    }
    
    // MARK: - Initialisers
    
    /**
    Default initializer
     
     - Parameters:
        - screen: a reference to the screen in order to be able to display game characters
     */
    init(screen: ScreenProtocol, warRules: WarRulesProtocol, battleRules: BattleRulesProtocol) {
        self.screen = screen
        self.warRules = warRules
        self.battleRules = battleRules
    }
    
    // MARK: - Private Functions
    
    private func newGame() {
        self.stopAdvance = true
        let service = WarFactory.sharedInstance.warService
        service.createWar(warRules: self.warRules, battleRules: self.battleRules, completion: { war, error in
            self.war = war
            self.lives = self.warRules.numberOfLives
            self.score = 0
            self.battle = self.war?.moveToNextBattle()
            self.battle?.delegate = self
            
            self.screen.clearScreen()
            
            self.displayHighScore() {
                self.play()
            }
        })
    }
    
    /**
     Lines up the next battle in the war and starts the enemy advancing
     */
    private func playNextBattle() {
        
        self.battle = self.war?.moveToNextBattle()
        
        // redefine the delegate on the battle to hear of significant events
        self.battle?.delegate = self
        
        // clear the battle rules in case there's any state from the previous battle (like cummulative scores)
        self.battle?.battleRules.clearState()
        self.play()
    }
    
    /**
     Set the screen up for a new game or wave, then start the enemies advancing
     */
    private func play() {
        self.stopAdvance = false // just in case?
        self.screen.clearScreen()
        self.screen.display(.one, screenPosition: 2)
        self.displayLives(lives: self.lives)
        
        self.advanceEnemies()
    }
    
    /**
     Increments the gun's value
     */
    private func aim() {
        // increment the gun value
        var value = self.screen.characterAt(2).rawValue
        if value > 9 {
            value = 0
        } else {
            value += 1
        }
        if let character = DigitalCharacter(rawValue: value) {
            self.screen.display(character, screenPosition: 2)
        }
    }
    
    /**
     Display the number of lives left as 1/2/3 bars
     */
    private func displayLives(lives: Int) {
        var character: DigitalCharacter = .threebars
        if lives == 2 { character = .twobars }
        else if lives == 1 { character = .onebar }
        self.screen.display(character, screenPosition: 3)
    }
    
    /**
     Handle what happens after an enemy dies, re display enemies to close the gap then wait the standard time interval before restarting the enemy advance.
     */
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
    
    /**
     Handle what happens at the end of a game - display score and Game Over message.
     */
    private func handleGameOver() {
        self.ignoreKeyPresses = true
        self.screen.clearScreen()
        self.displayScore()
        self.screen.displayTextMessage(text: "GAME OVER")
    }
    
    /**
     Show the high score on the screen
     */
    private func displayHighScore(completion: (() -> Void)? = nil) {
        
        self.ignoreKeyPresses = true
        
        let highscore: Int = 16430
        
        let message = String(highscore).leftPadding(toLength: 6, withPad: "0")
        self.screen.clearScreen()
        self.screen.displayTextMessage(text: "HIGH SCORE")
        self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
            self.ignoreKeyPresses = false
            completion?()
        }
    }
    
    /**
     Display the score (and level) in the format "0-000000", what a couple of seconds then call the completion callback
     */
    private func displayScore(completion: (() -> Void)? = nil) {
        if let level = self.war?.level {
            
            self.ignoreKeyPresses = true
            
            // pad out the score with leading zeros to make it exactly 6 characters long
            let scoreAsString = String(self.score).leftPadding(toLength: 6, withPad: "0")
            let message = "\(level)-\(scoreAsString)"
            self.screen.clearScreen()
            self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
                self.ignoreKeyPresses = false
                completion?()
            }
        } else {
            self.ignoreKeyPresses = false
            completion?()
        }
    }
    
    /**
     Shoot the current gun value at the enemies
     */
    private func shoot() {
        // get the value of the gun
        let value = self.screen.characterAt(2).rawValue
        self.battle?.shoot(value: value)
    }
    
    /**
     Recursive routine to advance the enemies step by step. Can be stopped when the ``stopAdvance`` flag is set to true.
     */
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
    
    /**
        Displays the enemies, as stored in ``self.battle?.battlefield``, waits the delay and calls the completion callback, if defined.
     */
    private func displayEnemies(delay: TimeInterval = TimeInterval(0), completion: (() -> Void)? = nil) {
        if let characters = self.battle?.battlefield.map( { ($0 != nil) ? DigitalCharacter(rawValue: $0!.value ) ?? .space : .space }) {
            self.screen.display(characters, screenPosition: self.screen.numberOfCharacters)
        }
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
}

// MARK: - KeyboardDelegate

extension SpaceInvaders: KeyboardDelegate {
    
    func keyPressed(key: CalculatorKey) {
        guard !self.ignoreKeyPresses else { return }
        
        if key == .game {
            // Start new game
            self.start()
        } else if key == .point {
            self.aim()
        } else if key == .plus {
            // shoot
            self.shoot()
        }
    }
}

// MARK: - BattleDelegate
extension SpaceInvaders: BattleDelegate {
    
    func battleLost() {
        self.lives -= 1
        if self.lives == 0 {
            self.handleGameOver()
        } else {
            // restart battle
            self.displayScore() {
                self.battle?.takeEnemiesOffBattlefield()
                self.battle?.battleRules.clearState()
                self.play()
            }
        }
    }
    
    func battle(_ battle: Battle, killedEnemy enemy: Enemy, index: Int) {
        if let level = self.war?.level {
            self.score += battle.battleRules.pointsForKillingEnemy(enemy: enemy, level: level)
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
            return battle.battleRules.shouldSpawnMothership(lastKillValue: value, level: level)
        }
        return false
    }
}

// MARK: - GamesProtocol

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
