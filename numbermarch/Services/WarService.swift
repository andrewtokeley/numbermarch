//
//  BattleService.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

protocol WarServiceInterface {
    func createWar(warRules: WarRulesProtocol, battleRules: BattleRulesProtocol, completion: ((War, Error?) -> Void)?)
    func createWar(battles: [Battle], warRules: WarRulesProtocol, battleRules: BattleRulesProtocol, completion: ((War, Error?) -> Void)?)
}

class WarService {
    
    private func createBattles(warRules: WarRulesProtocol, battleRules: BattleRulesProtocol) -> [Battle] {
        var battles:[Battle] = [Battle]()
        let availableArmyValues = [0,1,2,3,4,5,6,7,8,9]
        for level in 0...warRules.numberOfLevels - 1 {
            var armyValues: [Int] = [Int]()
            for _ in 0...warRules.numberOfEnemiesAtLevel(level: level) - 1 {
                if let enemy = availableArmyValues.randomElement() {
                    armyValues.append(enemy)
                } else {
                    // error?
                }
            }
            if let battle = try? Battle(armyValues: armyValues, rules: battleRules) {
                battle.battleRules = battleRules
                battles.append(battle)
            }
        }
        return battles
    }
}

extension WarService: WarServiceInterface {
    
    func createWar(warRules: WarRulesProtocol, battleRules: BattleRulesProtocol, completion: ((War, Error?) -> Void)?) {
        let battles = self.createBattles(warRules: warRules, battleRules: battleRules)
        let war = War(battles: battles, rules: warRules)
        completion?(war, nil)
    }
    
    func createWar(battles: [Battle], warRules: WarRulesProtocol, battleRules: BattleRulesProtocol, completion: ((War, Error?) -> Void)?) {
        
        let battles = battles
        battles.forEach { battle in
            battle.battleRules = battleRules
        }
        let war = War(battles: battles, rules: warRules)
        completion?(war, nil)
    }
}
