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
    
    /// Delegate protocol that lets implementations know of certain battle events (e.g. when a new enemy enters the battlefield)
    public var delegate: EightBattleDelegate?
    
    
    // MARK: - Public Properties
    
    /**
     Number of enemy kills in the battle
     */
    public var killCount: Int = 0
    
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
    init(screenSize: Int, delegate: EightBattleDelegate? = nil) {
        self.screenSize = screenSize
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    
    /**
     Called by clients to let Battle know they are ready to start a new game, including drawing the bombs.
     */
    public func readyForNewBattle() {
        self.setupBombs()
        self.enemy = nil
        self.missile = nil
    }
    /**
     Advance the eneny one space left or right depending on the enemy's direction
     */
    public func advanceEnemy() -> Bool {
        guard let enemy = self.enemy else { return false }
        guard enemy.isDead == false else { return false }
        
        let from = enemy.position
        enemy.position += enemy.direction.rawValue
        let to = enemy.position
        
        // Out of bounds
        if to < 1 || to > self.screenSize {
            enemy.position -= enemy.direction.rawValue
            self.handleBattleLost()
            return false
        }
        
        // Check hit
        let result = checkHit(enemy: enemy, missile: missile)
        if result == .miss {
            // No hit, so can let the delegate know to move the enemy
            delegate?.eightBattle(self, enemy: enemy, movedPositionFrom: from, to: to)
            return true
        } else {
            // undo the enemy's move
            enemy.position -= enemy.direction.rawValue
            
            if result == .hitAndNoKill {
                // remove the missile, the enemy will keep going
                self.removeMissile(missile)
                
            } else if result == .hitAndKill {
                // remove both the enemy and the missle and record kill
                self.killEnemy(enemy)
                self.removeMissile(missile)
            }
            return false
        }
    }
    
    /**
     Advance the missle one space towards the oncoming enemy (i.e. in the opposite direction).
     
     If the next move results in a hit, miss, explosion... then missile will not be moved but simply removed after the explosion.
     
     - Returns:
     Returns true if the missile actually moved, otherwise, if it hit something it will return false.
     */
    public func advanceMissile() -> Bool {
        // ignore if there is no missile
        guard let missile = self.missile else { return false }
        
        // Update position of the missile
        let from = missile.position
        missile.position += missile.direction.rawValue
        let to = missile.position

        // Out of bounds
        if to > self.screenSize || to < 1 {
            self.removeMissile(missile)
        }
        
        // Check hit
        let result = checkHit(enemy: enemy, missile: missile)
        if result == .miss {
            // No hit, so can let the delegate know to move the missile
            delegate?.eightBattle(self, missile: missile, movedPositionFrom: from, to: to)
            return true
        } else {
            // undo the missile's move
            missile.position -= missile.direction.rawValue
            
            if result == .hitAndNoKill {
                // remove the missile, the enemy will keep going
                self.removeMissile(missile)
                
            } else if result == .hitAndKill {
                // remove both the enemy and the missle and record kill
                self.killEnemy(enemy)
                self.removeMissile(missile)
            }
            return false
        }
    }
    
    /**
     Adds a missile to the battle. Missiles are added to the far left or right depending on the direction of the enemy.
     
     Missiles won't move unless calls are made to ``advanceMissile``.
     */
    public func addMissile(type: EightMissilleTypeEnum) {
        
        // add new missile off the screen ready to advance into view
        let position = self.enemy?.direction == .right ? self.screenSize : 1
        let direction = self.enemy?.direction.opposite ?? .right
        self.missile = EightMissile(type: type, position: position, direction: direction)
        
        let result = self.checkHit(enemy: enemy, missile: missile)
        if result == .hitAndKill {
            self.killEnemy(enemy)
            self.missile = nil
        } else {
            delegate?.eightBattle(self, addMissile: self.missile!, position: position)
        }
    }
    
    /**
     Called by the game to let the battle know the UI is ready to accept a new enemy into the battle.
     
     This method is ignore if an enemy already exists.
     
     The new enemy will be placed where the last dead enemy died, or at the far left heading right, if called for the first time.
     */
    public func readyForNextEnemy() {
        if let enemy = self.enemy {
            if enemy.isDead {
                // add a new enemy where the dead one was
                self.addEnemy(position: enemy.position, type: EightEnemyType.random(), direction: enemy.direction.opposite)
            } else {
                // you can't add another enemy if there is one on the battlefield
            }
        } else {
            // First enemy
            self.addEnemy(position: 1, type: EightEnemyType.random(), direction: EightDirection.right)
        }
        
    }
    
    // MARK: - Private Methods
    
    /**
     Checks whether an enemy and missile have collided and the result.
     
     This method will also advise the delegate of any required actions as a result of a collision. For example, removing the missile or enemy.
     */
    private func checkHit(enemy: EightEnemy?, missile: EightMissile?) -> HitResult {
        guard let enemy = enemy, let missile = missile else { return .miss }

        print("check hit")
        var result = HitResult.miss
        
        let hit = enemy.position == missile.position
        let kill = enemy.type.isCompletedBy(missile.type)
        
        if hit && !kill {
            // remove the missile, the enemy will keep going
            //self.removeMissile(missile)
            result = .hitAndNoKill
        } else if hit && kill {
            // remove both the enemy and the missle and record kill
//            self.killEnemy(enemy)
//            self.removeMissile(missile)
            result = .hitAndKill
        }
        print("check hit \(result)")
        return result
    }
    /**
     Called when an enemy has reached beyond the far left or right of battlefield
     */
    private func handleBattleLost() {
        delegate?.battleLost(self)
        
        if let missile = self.missile {
            removeMissile(missile)
        }
        if let enemy = self.enemy {
            removeEnemy(enemy)
        }
        self.enemy = nil
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
        
        enemy.isDead = true
        
        self.killCount += 1
        
        // Check for bombs
        let bomb = bombs[enemy.position - 1]
        if !bomb.exploded {
            bomb.exploded = true
            delegate?.eightBattle(self, bombExploded: bomb)
            
            if self.numberOfExplodedBombs == self.screenSize {
                delegate?.battleWon(self)
            }
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


