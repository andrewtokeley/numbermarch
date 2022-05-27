//
//  BattleService.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

protocol WarServiceInterface {
    func createWar(rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?)
}

class WarService {
    
    private func createBattles(rules: WarRulesProtocol) -> [Battle] {
        var battles:[Battle] = [Battle]()
        let availableArmyValues = [0,1,2,3,4,5,6,7,8,9]
        for level in 0...rules.numberOfLevels - 1 {
            var armyValues: [Int] = [Int]()
            for _ in 0...rules.numberOfEnemiesAtLevel(level: level) - 1 {
                if let enemy = availableArmyValues.randomElement() {
                    armyValues.append(enemy)
                } else {
                    // error?
                }
            }
            if let army = try? Battle(armyValues: armyValues) {
                battles.append(army)
            }
        }
        return battles
    }
}

extension WarService: WarServiceInterface {
    
    func createWar(rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?) {
        let battles = self.createBattles(rules: rules)
        let war = War(battles: battles) //, rules: rules)
        completion?(war, nil)
    }
    
}
