//
//  Battle.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/05/22.
//

import Foundation

/**
 Enumerator to identify unhandled errors related to a Battle instance.
 */
enum BattleError: Error {
    case ArmyHasNoEnemies
    case TooManyEnemiesInArmy
}

/**
 Represents a SpaceInvaders battle where digits move across the screen and you have to shoot them down before they get too close.
 
 Battle instances are typically used within a ``War`` instance to represent the waves of increasingly fast battles you must wage.
 */
class Battle {
    
    // MARK: - Public Properties
    
    /// Delegate protocol that lets implementations know of certain battle events (e.g. when a new enemy enters the battlefield)
    public var delegate: BattleDelegate?
    
    /**
     Enemies who are alive on the battlefield
     */
    public var enemies: [Enemy]! {
        return army.filter { $0.status == EnemyStatus.Alive }
    }
    
    // MARK: - Private Properties

    /**
     Internal representation of all the enemies in the enemy's army, even if they're not on the battle field yet
     */
    private var army: [Enemy]!
    
    /**
     Internal total of the cummulative total of all enemies shot. This is used to determine whether a mother ship should be added
     */
    private var shotTotal: Int = 0
    
    /**
    Returns the enemy that is lined up to enter the battlefield next.
     */
    private var nextEnemyIndex: Int? {
        return army.firstIndex(where: { $0.status == .Ready })
    }
    
    /**
     Returns the number of enemies still alive or ready to enter the battlefield
     */
    private var remainingEnemies: Int {
        let remaining = army.filter({ $0.status == .Alive || $0.status == .Ready })
        return remaining.count
    }
    
    // MARK: - Initialisers
    
    /**
     Default constructor
     */
    init(army: [Enemy], delegate: BattleDelegate? = nil) throws {
        guard army.count != 0 else { throw BattleError.ArmyHasNoEnemies }
        guard army.count <= 30 else { throw BattleError.TooManyEnemiesInArmy }
        
        self.delegate = delegate
        self.army = army
    }
    
    /**
     Specilaised constructor to simplify populating army from enemy values
     */
    convenience init(armyValues: [Int], delegate: BattleDelegate? = nil) throws {
        guard armyValues.count != 0 else { throw BattleError.ArmyHasNoEnemies }
        guard armyValues.count <= 30 else { throw BattleError.TooManyEnemiesInArmy }
        
        try self.init(
            army: armyValues.map( { return Enemy(value: $0) }),
            delegate: delegate
        )
    }
    
    // MARK: Private Methods
    
    /**
     Adds a mothership to the enemies army. It will be inserted before the current  nextEnemy and therefore will become the nextEnemy to enter the battlefield.
     
     Whether to add a Mothership is determined by asking the BattlefieldDelegate after each successful kill. Different war rules will determine the criteria. Classic rule is when you kills enemies whose values add up to a multiple of 10.
     */
    private func addMothership() {
        let mothership = Enemy(value: DisplayCharacter.mothership.rawValue, status: .Ready)
        
        // add the mothership before the nextEnemy
        if let index = self.nextEnemyIndex {
            self.army.insert(mothership, at: index)
        } else {
            // add to end
            self.army.append(mothership)
        }
    }
    
    // MARK: Methods
    
    /**
    Returns the enemy that is lined up to enter the battlefield next
     */
    public var nextEnemy: Enemy? {
        return army.first(where: { $0.status == .Ready })
    }
    /**
     Adds the next available enemy to the battlefield.
     */
    public func addNextEnemyToBattle() -> Enemy? {
        
        // get the next member of the army who is ready to fight
        if let index = army.firstIndex(where: { $0.status == .Ready })
        {
            self.army[index].status = .Alive
            //self.delegate?.battle(self, newEnemy: self.army[index])
            return self.army[index]
        }
        return nil
    }
    
    /**
     Moves the enemies that are on the battlefield into a ready status. Used when we want to reset the game without starting a new battle. Note that motherships will be lost and no points scored for them!
     */
    public func takeEnemiesOffBattlefield() {
        for i in 0...army.count - 1 {
            if army[i].status == .Alive {
                army[i].status = .Ready
            }
            if army[i].type == .Mothership {
                army[i].status = .Dead
            }
        }
    }
    
    /**
     Shoot at the enemies with a given value, the first enemy with a matching value will be killed. Can optionally supply a distance to record how far away the enemy was when you shot at it.
     
     - Note
     
     The distance parameter is typically sent from a user interface that is controlling the enemies path towards the player. The smaller the distance the closer they are to defeating the player. A long distance suggests a great shot and some war rules award more points.
     */
    public func shoot(value: Int, distance: CGFloat = 0) {
        
        // find the first enemy who is still alive and kill them!
        if let index = self.army.firstIndex(where: { $0.status == .Alive && $0.value == value }) {
            
            // mark the enemy as toast
            self.army[index].status = .Dead
        
            // keep a running total of the values of the enemies killed
            self.shotTotal += self.army[index].value
            
            // let listeners know a death occurred
            self.delegate?.battle(self, killedEnemy: army[index], distance: distance)
            
            // let listeners know if the battle is over
            if remainingEnemies == 0 {
                self.delegate?.battleAllEnemiesKilled(self)
            } else {
                // if the game isn't over yet, see if we need to add a mothership
                if self.delegate?.battle(self, shouldSpawnMotheshipAfterKillOfValue: value) ?? false {
                    self.addMothership()
                }
            }
            return
        }
        
        // let listeners know a shot was fired and missed
        self.delegate?.battle(self, shotMissedWithValue: value)        
    }
    
}
