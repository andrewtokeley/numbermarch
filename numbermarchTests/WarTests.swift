//
//  WarTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 16/05/22.
//

import XCTest
@testable import numbermarch

class WarTests: XCTestCase {
    
    var warService: WarServiceInterface!
    
    override func setUpWithError() throws {
        self.warService = WarFactory.sharedInstance.warService
    }

    override func tearDownWithError() throws {
        
    }

    func testWarCreatesCorrectNumberOfBattles() throws {
        let expectation = self.expectation(description: "testWarCreatesCorrectNumberOfBattles")
        var newWar: War?
        
        let warRules = TestWarRule()
        let battleRules = SpaceInvaderBattleRules()
        
        warService.createWar(warRules: warRules, battleRules: battleRules) { war, error in
            newWar = war
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(newWar?.battle)
        let _ = newWar?.moveToNextBattle() // first battle
        let _ = newWar?.moveToNextBattle() // second
        let _ = newWar?.moveToNextBattle() // third
        let noBattle = newWar?.moveToNextBattle() // should return nil
        XCTAssertNil(noBattle)
        
    }
    
    func testMothership10() {
        
        let battleRules = SpaceInvaderBattleRules()
        
        // create single battle for war
        let battle = try! Battle(armyValues: [1,7,3,5], rules: battleRules)
        battle.battleSize = 6
        
        // bring first 3 enemies on to screen
        let _ = battle.advanceEnemies() //1
        let _ = battle.advanceEnemies() //7
        let _ = battle.advanceEnemies() //3
        
        // these shots should spawn a mothership on next advance
        battle.shoot(value: 7)
        battle.shoot(value: 3)
        
        // advance once more to bring the mothership on
        let _ = battle.advanceEnemies() //n
        
        XCTAssertTrue(battle.battlefield.last??.value == DigitalCharacter.mothership.rawValue)
        
    }
    
    func testMothershipInSecondWave() {
        
        let battleRules = SpaceInvaderBattleRules()
        
        // create single battle for war
        let battle = try! Battle(armyValues: [1,7,3], rules: battleRules)
        battle.battleSize = 6
        
        // bring first 3 enemies on to screen
        let _ = battle.advanceEnemies() //1
        let _ = battle.advanceEnemies() //7
        let _ = battle.advanceEnemies() //3
        
        // advance one more time (no more enemies so the last spot will be a space)
        let _ = battle.advanceEnemies()
        XCTAssertNil(battle.battlefield.last!)
        
        // these shots should NOT spawn a mothership on next advance in this wave
        battle.shoot(value: 7)
        battle.shoot(value: 3)
        
        // advance once and check still nil
        let _ = battle.advanceEnemies()
        XCTAssertNil(battle.battlefield.last!)
        
        // restart the same battle - should remember to spawn a mothership
        battle.takeEnemiesOffBattlefield()
        let _ = battle.advanceEnemies()
        XCTAssertTrue(battle.battlefield.last??.value == DigitalCharacter.mothership.rawValue)
    }
}


class TestWarRule: WarRulesProtocol {
    var warDescription: String {
        return ""
    }
    
    func levelDescription(level: Int) -> String {
        return ""
    }
    
    func stepTimeInterval(level: Int) -> TimeInterval {
        return TimeInterval(1)
    }
    
    func shouldSpawnMothership(lastKillValue: Int, level: Int) -> Bool {
        return false
    }
    
    func clearState() {
        //
    }
    
    func numberOfEnemiesAtLevel(level: Int) -> Int {
        return 10
    }
    
    func pointsForKillingEnemy(enemy: Enemy, level: Int) -> Int {
        return 0
    }
    
    var numberOfLevels: Int {
        return 3
    }
    
    var numberOfLives: Int {
        return 0
    }
}
