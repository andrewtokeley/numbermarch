//
//  EightBattle.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

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
     Initialise a new battle with a given number of enemies
     */
    init(screenSize: Int, delegate: EightBattleDelegate? = nil) {
        self.screenSize = screenSize
        self.delegate = delegate
        self.initialiseGame()
    }
    
    // MARK: - Public Methods
    
    /**
     Initialise the game state for a new battle
     
     The first enemy will appear from the left hand side moving right.
     */
    public func initialiseGame() {
        setupBombs()
        addEnemy(position: 1, type: EightEnemyType.random(), direction: EightDirection.right)
    }

    /**
     Advance the eneny one space left or right depending on the enemy's direction
     */
    public func advanceEnemy() {
        guard let enemy = self.enemy else { return }
        guard enemy.isDead == false else { return }
        
        let from = enemy.position
        let to = enemy.position + enemy.direction.rawValue
        if to < 1 || to > self.screenSize {
            self.handleBattleLost()
        } else {
            enemy.position = to
        }
        
        delegate?.eightBattle(self, enemy: enemy, movedPositionFrom: from, to: to)
    }
    
    /**
     Advance the missle one space towards the oncoming enemy (i.e. in the opposite direction).
     
     If the next move results in a hit, miss, explosion... then missile will not be moved but simply removed after the explosion
     */
    public func advanceMissile() {
        // ignore if there is no missile
        guard let missile = self.missile else { return }
        
        // check what next advance will do
        let nextPosition = missile.position + missile.direction.rawValue
        let willHit = nextPosition == enemy?.position
        let willKill = enemy?.type.isCompletedBy(missile.type) ?? false
        let willDisappear = missile.position + missile.direction.rawValue > self.screenSize ||
                            missile.position + missile.direction.rawValue < 1
        
        if willDisappear {
            self.removeMissile(missile)
            
        } else if willHit {
            self.removeMissile(missile)
            
            if willKill {
                // killed enemy (and explode bomb, if one exists)
                if let enemy = enemy {
                    self.killEnemy(enemy)
                
                    // add a new enemy where this one was hit
                    self.addEnemy(position: enemy.position, type: EightEnemyType.random(), direction: enemy.direction.opposite)
                }
            }
            
        } else {
            
            // Not hits, just advance the missile as requested
            let fromPosition = missile.position
            missile.position += missile.direction.rawValue
            let toPosition = missile.position
            
            delegate?.eightBattle(self, missile: missile, movedPositionFrom: fromPosition, to: toPosition)
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
        
        delegate?.eightBattle(self, addMissile: self.missile!, position: position)
    }
    
    // MARK: - Private Methods
    
    /**
     Called when an enemy has reached beyond the far left or right of battlefield
     */
    private func handleBattleLost() {
        delegate?.battleLost(self)
        self.enemy = nil
    }
    
    /**
     Removes missile from the battle and advises delegate
     */
    private func removeMissile(_ missile: EightMissile) {
        delegate?.eightBattle(self, removeMissile: missile)
        self.missile = nil
    }
    
    private func killEnemy(_ enemy: EightEnemy) {
        self.killCount += 1
        
        // Check for bombs
        let bomb = bombs[enemy.position - 1]
        if !bomb.exploded {
            bomb.exploded = true
            delegate?.eightBattle(self, bombExploded: bomb)
        }
        
        enemy.isDead = true
        
        delegate?.eightBattle(self, enemyKilled: enemy)
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
