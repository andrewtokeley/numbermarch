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
        
        let rules = TestWarRule()
        warService.createWar(rules: rules) { war, error in
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
        let expectation = self.expectation(description: "testMothership10")
        var newWar: War?
        
        let rules = Mod10WarRules()
        warService.createWar(rules: rules) { war, error in
            newWar = war
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
       
        let battle = newWar?.moveToNextBattle() // first battle
        let _ = battle?.advanceEnemies()
        
        
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

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
