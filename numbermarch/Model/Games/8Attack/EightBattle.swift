//
//  EightBattle.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

private enum HitResult: Int {
    case miss = 0
    case hitAndNoKill
    case hitAndKill
}

class EightBattle {
    
    // MARK: - Private Properties
    
    /**
     The types the advancing enemy iterates through as it moves acros the screen. For most levels this is the same type for each step, but for toggle levels it alternates between two types. See ``readyForNextLevel`` for this property to be set.
     */
    var enemiesInAdvance: [EightEnemyType] = [EightEnemyType.random()]
    
    /**
     Returns the enemy type to use as the enemy advances across the screen. This routine iterates through the elements of the ``enemiesInAdvance`` array, as defined at the beginning of each level.
     */
    private var nextEnemyType: EightEnemyType {
        guard enemiesInAdvance.count >= 1 else { return EightEnemyType.random() }
        
        if enemiesInAdvance.count == 1 {
            return enemiesInAdvance[0]
        } else {
            // current index
            if let index = enemiesInAdvance.firstIndex(where: { $0 == enemy?.type }) {
                let nextIndex = index < (self.enemiesInAdvance.count - 1) ? index + 1 : 0
                return enemiesInAdvance[nextIndex]
            } else {
                return enemiesInAdvance[0]
            }
        }
            
            
    }
    
    /**
     Returns whether there are more levels to play
     */
    private var hasMoreLevels: Bool {
        return self.level < self.rules.numberOfLevels
    }
    
    /**
     Returns whether the player has more lives
     */
    private var hasMoreLives: Bool {
        return self.lives > 0
    }
    /**
     Returns whether their are any more bombs to explode
     */
    private var isLevelOver: Bool {
        // check that there are more enemies needed for this level
        return self.numberOfExplodedBombs == self.screenSize
    }
    
    /**
     Rules of the game
     */
    private var rules : EightAttackRules
    
    /**
     Internal property to update the enemy's type when next advancing
     */
    private var changeEnemyTypeTo: EightEnemyType?
    
    
    // MARK: - Public Properties
    
    /// Delegate protocol that lets implementations know of certain battle events (e.g. when a new enemy enters the battlefield)
    public var delegate: EightBattleDelegate?
    
    /**
     Current score
     */
    public var score: Int = 0
    
    /**
     The level being played
     */
    public var level: Int = 1
    
    /**
     Number of lives left
     */
    public var lives: Int = 0
    
    /**
     Enemy currently on battlefield
     */
    public var enemy: EightEnemy?
    
    /**
     The missile being fired (or hidden if nil)
     */
    public var missile: EightMissile? = nil
    
    /**
     Bombs to explode
     */
    public var bombs: [EightBomb] = [EightBomb]()
    
    /**
     Returns the number of enemies that have appeared in the level
     */
    public var enemiesAppearingInLevel: Int = 0
    
    /**
     Size of the screen
     */
    public var screenSize: Int
    
    /**
     Number of exploded bombs on the ballefield
     */
    public var numberOfExplodedBombs: Int {
        return bombs.filter({ $0.exploded }).count
    }
    
    // MARK: - Initilisers
    
    /**
     Initialise a new battle with a given number of enemies.
     
     This method will not bring the first enemy on to the battlefield. To do this call the ``readyForNextEnemy`` method when the UI client is ready.
     
     ```
     // From the user interface
     let battle = EightBattle(screenSize: 9)
     battle.delegate = self
     
     // When the UI is ready to receive calls on its delegate to add the first enemy...
     battle.readyForNextEnemy()
    ```
            
     */
    init(screenSize: Int, rules: EightAttackRules, delegate: EightBattleDelegate? = nil) {
        self.rules = rules
        self.screenSize = screenSize
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    /**
     Called by the client to start a new game. This call will initalise game state and call the newLevel delegate method.
     
     Note, from the newLevel delegate, the client must call readyForNextLevel in order to start the game.
     */
    public func readyToStartGame() {
        self.level = 1
        self.score = 0
        self.enemiesAppearingInLevel = 0
        self.lives = rules.numberOfLives
        delegate?.eightBattle(self, newLevel: 1, score: 0)
    }
    
    /**
     Set the game up for the next level. Will let the delegate know to draw new bombs.
     
     There is no reason to call ``readyForNextEnemy``. After calling this method the first new enemy will be advised on the delegate.
     
     */
    public func readyForNextLevel() {
        guard hasMoreLevels else { return }
            
        // reset bombs and let delegate know
        self.setupBombs()
        self.enemy = nil
        self.missile = nil
        self.enemiesAppearingInLevel = 0
        
        // assume the client is also ready to accept the first enemy of the level
        self.readyForNextEnemy()

    }
    
    /**
     Called by the client to restart a level after losing a life
     */
    public func readyToRestartLevel() {
        
        // don't reset the bombs, just let the delegate know to redraw them
        delegate?.eightBattle(self, bombsCreated: self.bombs)
        
        self.enemy = nil
        self.missile = nil
        
        // assume the client is also ready to accept the first enemy
        self.readyForNextEnemy()
    }
    
    /**
     Advance the eneny one space left or right depending on the enemy's direction
     */
    public func advanceEnemy() -> Bool {
        guard let enemy = self.enemy else { return false }
        guard enemy.isDead == false else { return false }
        
        let to = enemy.position + enemy.direction.rawValue
        let toType = self.nextEnemyType
        if to < 1 || to > self.screenSize {
            self.handleBattleLost()
            return false
        }
        
        // Will advancing the enemy kill it?
        var kill = false
        var hit = false
        if let missile = self.missile {
            hit = missile.position == to
            kill = hit && toType.isCompletedBy(missile.type)
        }
        
        // Regardless always move the enemy first
        enemy.type = toType
        delegate?.eightBattle(self, enemy: enemy, movedPositionFrom: enemy.position, to: to)
        enemy.position = to
        
        if hit {
            self.missile = nil
        }

        // Then kill it off it needed
        if kill {
            self.killEnemy(enemy)
            self.missile = nil
        }
        
        return true
    }
    
    /**
     Advance the missle one space towards the oncoming enemy (i.e. in the opposite direction).
     
     If the next move results in a hit, miss, explosion... then missile will not be moved but simply removed after the explosion.
     
     - Returns:
     Returns true if the missile actually moved, otherwise, if it hit something it will return false.
     */
    public func advanceMissile() -> Bool {
        guard let missile = self.missile else { return false }
        
        let to = missile.position + missile.direction.rawValue
        if to < 1 || to > self.screenSize {
            self.removeMissile(missile)
            return false
        }
        
        // Will advancing the missile kill an enemy?
        var kill = false
        var hit = false
        if let enemy = self.enemy {
            hit = enemy.position == to
            kill = hit && enemy.type.isCompletedBy(missile.type)
        }
        
        if hit {
            // if an enemy was hit remove the missile
            self.missile = nil
            delegate?.eightBattle(self, removeMissile: missile)
        } else {
            // if nothing was hit, move the missile as requested
            delegate?.eightBattle(self, missile: missile, movedPositionFrom: missile.position, to: to)
            missile.position = to
        }
        
        if kill {
            self.killEnemy(enemy)
        }
        return true
//
//        // Update position of the missile
//        let from = missile.position
//        missile.position += missile.direction.rawValue
//        let to = missile.position
//
//        // Out of bounds
//        if to > self.screenSize || to < 1 {
//            self.removeMissile(missile)
//        }
//
//        // Check if the next move would hit the enemy
//        let result = checkHit(enemy: enemy, missile: missile)
//        if result == .miss {
//            delegate?.eightBattle(self, missile: missile, movedPositionFrom: from, to: to)
//            return true
//        } else {
//            // undo the missile's move, so we can remove it from it's current position
//            missile.position -= missile.direction.rawValue
//            self.removeMissile(missile)
//
//            // if the ememy was killed, remove it
//            if result == .hitAndKill {
//                self.killEnemy(enemy)
//            }
//            return false
//        }
    }
    
    /**
     Adds a missile to the battle. Missiles are added to the far left or right depending on the direction of the enemy.
     
     Missiles won't move unless calls are made to ``advanceMissile``.
     */
    public func addMissile(type: EightMissilleTypeEnum) {
        
        if let enemy = self.enemy {
            // add new missile off the screen ready to advance into view
            let position = enemy.direction == .right ? self.screenSize : 1
            let direction = enemy.direction.opposite
            self.missile = EightMissile(type: type, position: position, direction: direction)
            
            if let missile = self.missile {
                if enemy.position == missile.position && enemy.type.isCompletedBy(missile.type) {
                    self.killEnemy(enemy)
                    self.missile = nil
                } else {
                    delegate?.eightBattle(self, addMissile: self.missile!, position: position)
                }
            }
        }
    }
    
    /**
     Called by the game to let the battle know the UI is ready to accept a new enemy into the battle.
     
     This method is ignore if an enemy already exists.
     
     The new enemy will be placed where the last dead enemy died, or at the far left heading right, if called for the first time.
     */
    public func readyForNextEnemy() {
        
        if !isLevelOver {
            // If this level is a toggle level then determine which types to toggle between, if it's not the enemy type stays the same for each advance of the enemy
            let randomType = EightEnemyType.random()
            if rules.shouldToggleEnemyType(level: self.level) {
                self.enemiesInAdvance = [randomType, randomType.not()]
            } else {
                self.enemiesInAdvance = [randomType]
            }
            
            // Bring on another enemy
            if let enemy = self.enemy {
                if enemy.isDead {
                    // add a new enemy where the dead one was
                    self.enemiesAppearingInLevel += 1
                    self.addEnemy(position: enemy.position, type: self.nextEnemyType, direction: enemy.direction.opposite)
                } else {
                    // Pretty sure this won't happen, but...
                    // you can't add another enemy if there is one on the battlefield
                }
            } else {
                // This is the first enemy of a new level, add to the far left, moving right.
                self.enemiesAppearingInLevel = 1
                self.addEnemy(position: 1, type: self.nextEnemyType, direction: EightDirection.right)
            }
        } else {
            if self.hasMoreLevels {
                self.level += 1
                delegate?.eightBattle(self, newLevel: self.level, score: self.score)
            } else {
                self.gameOver(completedAllLevels:true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func gameOver(completedAllLevels: Bool) {
        if completedAllLevels {
            delegate?.battleWon(self)
        } else {
            delegate?.battleGameOver(self)
        }
    }
    
    public func enemyDistanceFromStart(_ enemy: EightEnemy) -> Int {
        if enemy.direction == .left {
            return self.screenSize - enemy.position
        } else {
            // heading left
            return enemy.position
        }
    }
    
    /**
     Checks whether an enemy and missile have collided and the result.
     
     This method will also advise the delegate of any required actions as a result of a collision. For example, removing the missile or enemy.
     */
    private func checkHit(enemy: EightEnemy?, missile: EightMissile?) -> HitResult {
        guard let enemy = enemy, let missile = missile else { return .miss }

        var result = HitResult.miss
        
        let hit = enemy.position == missile.position
        let kill = enemy.type.isCompletedBy(missile.type)
        
        if hit && !kill {
            // remove the missile, the enemy will keep going
            result = .hitAndNoKill
        } else if hit && kill {
            // remove both the enemy and the missle and record kill
            result = .hitAndKill
        }
        print("checkhit result. enemy.position=\(enemy.position), missile.position=\(missile.position)")
        print("checkhit result. enemy.type=\(enemy.type), missile.type=\(missile.type)")
        print("checkhit result = \(result)")
        return result
    }
    
    /**
     Called when an enemy has reached beyond the far left or right of battlefield
     */
    private func handleBattleLost() {
        
        self.lives -= 1
        
        if let missile = self.missile {
            removeMissile(missile)
        }
        if let enemy = self.enemy {
            removeEnemy(enemy)
        }
        self.enemy = nil
        
        if self.lives >= 1 {
            delegate?.eightBattle(self, lostLife: self.lives)
        } else {
            delegate?.battleGameOver(self)
        }
    }
    
    /**
     Removes missile from the battle and advises delegate
     */
    private func removeMissile(_ missile: EightMissile?) {
        guard let missile = missile else { return }

        delegate?.eightBattle(self, removeMissile: missile)
        self.missile = nil
    }
    
    /**
     Removes missile from the battle and advises delegate
     */
    private func removeEnemy(_ enemy: EightEnemy) {
        delegate?.eightBattle(self, removeEnemy: enemy)
        self.enemy = nil
    }
    
    /**
     Called when the missile hits an enemy and turns it into an 8 (i.e. kills it)
     */
    private func killEnemy(_ enemy: EightEnemy?) {
        guard let enemy = enemy else { return }
        
        // Check for bombs
        let bomb = bombs[enemy.position - 1]
        if !bomb.exploded {
            bomb.exploded = true
            
            self.score += rules.scoreForExplodingBomb(level: 1, shotDistance: self.enemyDistanceFromStart(enemy))
            
            delegate?.eightBattle(self, bombExploded: bomb)
            
        }
        
        enemy.isDead = true
        
        delegate?.eightBattle(self, enemyKilled: enemy)
    }
    
    /**
     Called when a missile hits an enemy but it's the wrong type
     */
    private func missedEnemy(_ enemy: EightEnemy) {
        delegate?.eightBattle(self, removeEnemy: enemy)
    }
    
    /**
     Add a new enemy to the battle
     */
    private func addEnemy(position: Int, type: EightEnemyType, direction: EightDirection) {
        self.enemy = EightEnemy(type: type, direction: direction)
        self.enemy!.position = position
        self.delegate?.eightBattle(self, addEnemy: enemy!, position: position)
    }

    /**
    Add unexploded bombs to the game
     */
    private func setupBombs() {
        self.bombs.removeAll()
        for i in 1...self.screenSize {
            self.bombs.append(EightBomb(exploded: false, position: i))
        }
        delegate?.eightBattle(self, bombsCreated: self.bombs)
    }
    
    // MARK: - Debug
    
    /**
     Returns a string description of the current battle state. Primarily used for debugging and testing purposes
     */
    public var state: [String] {
        
        // create [1,2,3,4 ... screenSize]
        var positions = [Int]()
        for i in 1...self.screenSize {
           positions.append(i)
        }
        
        var result = [
            String(repeating: " ", count: self.screenSize),
            String(repeating: " ", count: self.screenSize),
            String(repeating: " ", count: self.screenSize),
        ]
        
        result[0] = positions.map({ self.bombs[$0-1].exploded ? " " : "." }).joined()
        result[1] = positions.map({ $0 == self.enemy?.position ? self.enemy!.asText : " " }).joined()
        
        if let missile = self.missile {
            result[2] = positions.map({ $0 == missile.position ? "-" : " " }).joined()
        }
        return result
        
    }
    
}


