//
//  War.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 16/05/22.
//

import Foundation

/**
 A War class represents a set of Battles that need to be fought before victory is achieved.
 */
class War {
    
    // MARK: - Private Properties
    
    private var battles: [Battle]
    private var battleIndex: Int = -1
    
    // MARK: - Public Properties
    
    public var rules: WarRulesProtocol
    
    public var battle: Battle? {
        return (battleIndex >= 0 && battleIndex <= battles.count - 1) ? battles[battleIndex] : nil
    }
    public var level: Int = 0

    // MARK: - Initialisers
    
    init(battles: [Battle], rules: WarRulesProtocol) {
        self.battles = battles
        self.rules = rules
    }
    
    // MARK: - Public Methods
    
    public func moveToNextBattle() -> Battle? {
        if self.battleIndex == (battles.count - 1) {
            // no more battles
            return nil
        }
        // move pointer to next level/battle
        self.battleIndex += 1
        self.level += 1
        return self.battle

    }
    
}