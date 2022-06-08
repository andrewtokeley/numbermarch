//
//  BattleService.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

protocol WarServiceInterface {
    func createWar(rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?)
    func createWar(battles: [Battle], rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?)
}

class WarService {
    
    private func createBattles(rules: WarRulesProtocol) -> [Battle] {
        var battles:[Battle] = [Battle]()
        let availableArmyValues = [0,1,2,3,4,5,6,7,8,9]
        for level in 1...rules.numberOfLevels {
            var armyValues: [Int] = [Int]()
            for _ in 1...rules.numberOfEnemiesAtLevel(level: level) {
                if let enemy = availableArmyValues.randomElement() {
                    armyValues.append(enemy)
                } else {
                    // error?
                }
            }
            if let battle = try? Battle(armyValues: armyValues, rules: rules) {
                battle.battleSize = rules.numberOfSpacesForEnemies(level: level)
                battle.level = level
                battles.append(battle)
            }
        }
        return battles
    }
}

extension WarService: WarServiceInterface {
    
    func createWar(rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?) {
        let battles = self.createBattles(rules: rules)
        let war = War(battles: battles, rules: rules)
        completion?(war, nil)
    }
    
    func createWar(battles: [Battle], rules: WarRulesProtocol, completion: ((War, Error?) -> Void)?) {
        let battles = battles
        var level = 0
        battles.forEach { battle in
            level += 1
            battle.rules = rules
            battle.level = level
        }
        let war = War(battles: battles, rules: rules)
        completion?(war, nil)
    }
}
