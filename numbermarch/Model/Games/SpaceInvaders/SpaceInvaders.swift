//
//  SpaceInvaders.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

class SpaceInvaders {
    
    // MARK: - Private Properties
    
    public let id: String = UUID().uuidString
    
    /**
     Reference to the screen onto which the game is presented
     */
    private var screen: ScreenProtocol
    
    /**
     Reference to the war instance that represents a series of increasingly fast battle advances
     */
    private var war: War!
    
    /**
     The rules of war
     */
    private var rules: WarRulesProtocol
    
    /**
     Internal flag to advise whether a game is in play or not
     */
    private var gameActive: Bool = false
    
    /**
     The rules of the battle
     */
    //private var battleRules: BattleRulesProtocol
    
    /**
     Reference to the current score
     */
    //private var score: Int = 0
    
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
     
     Note this won't ignore requests from the calculator to pause/resume/start
     */
    private var ignoreKeyPresses: Bool = false
    
    /**
     The TimeInterval that represents how long each game step takes
     */
    private var timeInterval: TimeInterval {
        guard war != nil else { return 1 }
        return self.rules.stepTimeInterval(level: self.war.level)
    }
    
    // MARK: - Initialisers
    
    /**
    Default initializer
     
     - Parameters:
        - screen: a reference to the screen in order to be able to display game characters
        - rules: the rules of the game
     */
    init(screen: ScreenProtocol, rules: WarRulesProtocol) {
        self.screen = screen
        self.rules = rules
    }
    
    // MARK: - Private Functions
    
    private func newGame() {
        self.stopAdvance = true
        self.war = nil
        
        let service = WarFactory.sharedInstance.warService
        service.createWar(rules: self.rules, completion: { war, error in
            self.war = war
            self.war.delegate = self
            self.lives = self.rules.numberOfLives
            self.screen.clearScreen()
            
            let scoreService = ScoreService()
            scoreService.getHighscore(gameName: self.name) { highscore, error in
                self.displayHighScore(highscore) {
                    self.displayStartMessage {
                        self.gameActive = true
                        // ready the war for the first battle
                        try! self.war?.startWar()
                    }
                }
            }
        })
    }
    
    /**
     Lines up the next battle in the war and starts the enemy advancing
     
     - Returns:
        Returns true if there was another battle to wage, otherwise false, indicating you've won the war!
     */
//    private func playNextBattle() {
//        guard war != nil else { return }
//
//        self.battle = self.war.moveToNextBattle()
//
//        if self.rules.shouldGetExtraLife(level: self.war.level) && self.lives < self.rules.numberOfLives {
//            self.lives += 1
//        }
//
//        // redefine the delegate on the new battle to hear of significant events
//        self.battle?.delegate = self
//
//        // clear the battle rules in case there's any state from the previous battle (like cummulative scores)
//        self.battle?.rules?.clearState()
//        self.play()
//    }
    
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
    private func handleGameOver(didWin: Bool) {
        self.screen.clearScreen()
        
        // display the level-score for a couple of seconds
        self.screen.displayTextMessage(text: didWin ? "YOU WON!" : "GAME OVER")
        self.displayScore() {
            self.gameActive = false
            self.ignoreKeyPresses = true
            
            // now see if we have a highscore
            let service = ScoreService()
            service.getHighscore(gameName: self.name) { highscore, error in
                if let error = error {
                    print(error)
                } else {
                    // New Highscore!
                    if self.war.score > highscore {
                        service.saveHighscore(gameName: self.name, score: self.war.score) { error in
                            self.displayHighScore(self.war.score)
                        }
                    }
                }
            }
        }
    }
    
    
    /**
     Show the high score on the screen
     */
    private func displayHighScore(_ highscore: Int, completion: (() -> Void)? = nil) {
        
        self.ignoreKeyPresses = true
        
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
     
     Calling this method will also remove any other text that was being displayed at the time.
     */
    private func displayScore(completion: (() -> Void)? = nil) {
        guard war != nil else {
            self.ignoreKeyPresses = false
            completion?()
            return
        }
            
        self.ignoreKeyPresses = true
        
        // pad out the score with leading zeros to make it exactly 6 characters long
        let scoreAsString = String(self.war.score).leftPadding(toLength: 6, withPad: "0")
        let message = "\(war.level)-\(scoreAsString)"
        self.screen.clearScreen(includingMessageText: false)
        self.screen.display(message, screenPosition: self.screen.numberOfCharacters, delay: TimeInterval(2)) {
            self.ignoreKeyPresses = false
            completion?()
        }
    }
    
    /**
     Displays the opening string for a new game, e.g. 16-30 to describe the number of enemies and number of shots you have
     
     Calling this method will also remove any other text that was being displayed at the time.
     */
    private func displayStartMessage(completion: (() -> Void)?) {
        self.screen.clearScreen()
        self.screen.display(
            "\(self.rules.numberOfEnemiesAtLevel(level: 1))-\(self.rules.numberOfShotsAtLevel(level: 1))",
            screenPosition: self.screen.numberOfCharacters,
            delay: TimeInterval(2)) {
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
     Recursive routine to advance the enemies step by step. Can be stopped by setting the ``stopAdvance`` flag to true
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
            
            self.screen.display(characters, screenPosition: 3 + (self.battle?.battleSize ?? 6))
        }
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    private func startBattle(_ battle: Battle) {
        // redefine the delegate on the new battle to hear of significant events
        self.battle = battle
        self.battle?.delegate = self
        
        // check if you deserve an extra life
        if self.rules.shouldGetExtraLife(level: self.war.level) && self.lives < self.rules.numberOfLives {
            self.lives += 1
        }
        
        // clear the battle rules in case there's any state from the previous battle (like cummulative scores)
        self.battle?.rules?.clearState()
        
        self.play()
    }
}

// MARK: - KeyboardDelegate

extension SpaceInvaders: KeyboardDelegate {
    
    /**
     Called by the calculator when a key has been pressed.
     
     Key presses are ignored if the ``ignoreKeyPresses`` flag has been set.
     */
    func keyPressed(key: CalculatorKey) {
        guard !self.ignoreKeyPresses else { return }
        
        if key == .point {
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
            self.handleGameOver(didWin: false)
        } else {
            // restart battle
            self.displayScore() {
                self.battle?.takeEnemiesOffBattlefield()
                self.battle?.rules?.clearState()
                self.play()
            }
        }
    }
    
    func battle(_ battle: Battle, killedEnemy enemy: Enemy, index: Int) {
        guard war != nil else { return }
        self.handleKill()
    }
    
    func battle(_ battle: Battle, shotMissedWithValue: Int) {
        // do nothing for now, but should decrement hit count
    }
    
    func battleAllEnemiesKilled(_ battle: Battle) {
        let _ = self.war.moveToNextBattle()
    }
    
    func battle(_ battle: Battle, shouldSpawnMotheshipAfterKillOfValue value: Int) -> Bool {
        guard war != nil else { return false }
        return battle.rules?.shouldSpawnMothership(lastKillValue: value, level: war.level) ?? false
    }
}

// MARK: - GamesProtocol

extension SpaceInvaders: GamesProtocol {
    
    var name: String {
        return "Digit Invaders"
    }
    
    var isGameStarted: Bool {
        return self.gameActive
    }
    
    var isPaused: Bool {
        return self.stopAdvance
    }
    
    func start() {
        self.newGame()
    }
    
    func stop() {
        self.stopAdvance = true
    }
    
    func pause() {
        self.stopAdvance = true
        self.ignoreKeyPresses = true
        self.screen.displayTextMessage(text: "PAUSED")
    }
    
    func resume() {
        self.stopAdvance = false
        self.ignoreKeyPresses = false
        self.screen.displayTextMessage(text: "")
        self.advanceEnemies()
    }
}

// MARK: - WarDelegate

extension SpaceInvaders: WarDelegate {
    
    func war(_ war: War, newBattle battle: Battle) {
        
        if battle.level != 1 {
            self.displayScore() {
                self.startBattle(battle)
            }
        } else {
            self.startBattle(battle)
        }
        
    }
    
    func war(_ war: War, warWonWithScore score: Int) {
        self.handleGameOver(didWin: true)
    }
    
    
}
