//
//  War.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/05/22.
//

import Foundation

enum WarErrors: Error {
    case WarHasNoBattlesError
}
/**
 A War class represents a set of Battles that need to be fought before victory is achieved.
 */
class War {
    
    // MARK: - Private Properties
    
    private var battles: [Battle]
    private var battleIndex: Int = -1
    
    // MARK: - Public Properties
    
    /**
     The rules of the war, applied to all battles.
     */
    public var rules: WarRulesProtocol
    
    /**
     Delegate to advice of significant war events
     */
    public var delegate: WarDelegate?
    
    /**
     Returns the current battle
     */
    public var battle: Battle? {
        guard self.battleIndex >= 0 && self.battleIndex <= self.numberOfBattles - 1 else { return nil }
        
        return self.battles[self.battleIndex]
    }
    
    /**
     Returns how many battles are in the war
     */
    public var numberOfBattles: Int {
        return self.battles.count
    }
    
    /**
     Returns the number of battles left to fight
     */
    public var remainingBattles: Int {
        return self.numberOfBattles - (self.battleIndex + 1)
    }
    /**
     Returns the level of the current battle. If there are no battles then the property will return the value 0.
     */
    public var level: Int {
        return self.battle?.level ?? 0
    }

    /**
     Returns the current score of the war, which is the sum of the scores achieved within each battle.
     */
    public var score: Int {
        return self.battles.reduce(0) { $0 + $1.score }
    }
    
    // MARK: - Initialisers
    
    /**
     Creates a new war instance containing the given battles and rule set.
     */
    init(battles: [Battle], rules: WarRulesProtocol) {
        self.battles = battles
        self.rules = rules
        
        // set the first battle as the current one
        self.battleIndex = 0
    }
    
    // MARK: - Public Methods
    
    /**
     Initiates a new war. Once the first battle is ready the newBattle WarDelegate method will be called
     */
    public func startWar() throws {
        guard battles.count > 0 else { throw WarErrors.WarHasNoBattlesError }
        
        // point to first battle and let the delegate know
        self.battleIndex = 0
        self.delegate?.war(self, newBattle: self.battle!)
    }
    
    // MARK: - Private Methods
    
    /**
     Increments to the next battle in the war. This method can be called synchronously and work with the returned ``Battle`` instance, or callers can implement the ``WarDelegate`` to respond to new battles and when a war has been won. The delegate method will give more information about the state of the war.
     
     - Returns:
     Returns the new current battle, or nil if there are no more battles to fight
     */
    public func moveToNextBattle() -> Battle? {
        
        // check if we're through all the battles
        if self.remainingBattles == 0 {
            // you win!
            self.delegate?.war(self, warWonWithScore: self.score)
            
            return nil
            
        } else {
            // move pointer to next battle
            self.battleIndex += 1
            
            // let delegate know there's a new battle ready
            self.delegate?.war(self, newBattle: self.battle!)
            
            return self.battle
        }
    }

}

