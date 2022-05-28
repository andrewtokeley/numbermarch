//
//  numbermarchTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 13/05/22.
//

import XCTest
@testable import numbermarch

class numbermarchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewBattle() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 6)
        XCTAssertTrue(battle.enemies.count == 0)
        XCTAssertTrue(battle.battlefield.count == 6)
        XCTAssertTrue(battle.battlefield.filter({ $0 == nil }).count == 6)
    }
    
    func testNewBattleFromValues() throws {
        let battle = try! Battle(armyValues: [1,2,3,4,5])
        XCTAssertTrue(battle.enemies.count == 0)
    }
    
    func testAdvanceEnemy() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 6)
        
        let _ = battle.advanceEnemies()
        XCTAssertTrue(battle.enemies.count == 1, "Should be one enemy on the battlefield")
        XCTAssertTrue(battle.enemies[0].value == 1)
        XCTAssertTrue(battle.battlefield[5]?.value == 1)
    }
    
    func testAdvanceEnemySmallArmy() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3)
            ], battleSize: 6)
        
        let _ = battle.advanceEnemies() //1
        let _ = battle.advanceEnemies() //2
        let _ = battle.advanceEnemies() //3
        let _ = battle.advanceEnemies() // should move 123 closer, leaving space at end
        
        XCTAssertTrue(battle.enemies.count == 3, "Should be one enemy on the battlefield")
        XCTAssertNil(battle.battlefield.last!)
        XCTAssertNil(battle.battlefield.first!)
    }
    
    func testPushBackEnemies() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3)
            ], battleSize: 6)
        
        let _ = battle.advanceEnemies() //1
        let _ = battle.advanceEnemies() //2
        let _ = battle.advanceEnemies() //3
        
        XCTAssertTrue(battle.battlefield[3]?.value == 1)
        battle.shoot(value: 2) // should push back 1
        XCTAssertNil(battle.battlefield[3])
        XCTAssertTrue(battle.battlefield[4]?.value == 1)
    }
    
    func testEnemyWon() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 3)
        
        XCTAssertTrue(battle.advanceEnemies())
        XCTAssertTrue(battle.advanceEnemies())
        XCTAssertTrue(battle.advanceEnemies())
        
        // returns false means the delegate method enemiesWon() will be called
        XCTAssertFalse(battle.advanceEnemies())
    }

    func testShootAndKill() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 6)
        
        // advance 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        
        XCTAssertTrue(battle.enemies.count == 3)
        battle.shoot(value: 2)
        XCTAssertTrue(battle.enemies.count == 2)
        let lastIndex = battle.battleSize - 1
        XCTAssertTrue(battle.battlefield[lastIndex]?.value == 3)
        XCTAssertTrue(battle.battlefield[lastIndex - 1]?.value == 1)
        XCTAssertNil(battle.battlefield[lastIndex - 2])
    }
    
    func testShootAndKillLastOnBattlefield() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 6)
        
        // advance 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        battle.shoot(value: 1)
        battle.shoot(value: 2)
        battle.shoot(value: 3)
        
        // test battlefield empty
        XCTAssertTrue(battle.enemies.count == 0)
        
        let _ = battle.advanceEnemies() // 4
        
        // test battelfield has only on enemy at the end, equal to 4
        XCTAssertTrue(battle.enemies.count == 1)
        XCTAssertTrue(battle.battlefield.last??.value == 4)
    }
    
    func testShootAndMiss() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ], battleSize: 6)
        
        // advance 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        
        XCTAssertTrue(battle.enemies.count == 3)
        battle.shoot(value: 5)
        XCTAssertTrue(battle.enemies.count == 3)
    }
    
    func testRemaining() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            ], battleSize: 6)
        
        // advance all 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        
        XCTAssertTrue(battle.remainingEnemies == 3)
        battle.shoot(value: 1)
        XCTAssertTrue(battle.remainingEnemies == 2)
        battle.shoot(value: 2)
        battle.shoot(value: 3)
        XCTAssertTrue(battle.remainingEnemies == 0)
    }
    
    func testCantAdvanceAfterAllDead() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            ], battleSize: 6)
        
        // advance all 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        
        // kill all
        battle.shoot(value: 1)
        battle.shoot(value: 2)
        battle.shoot(value: 3)
        
        // check you can't advance
        let canAdvance = battle.advanceEnemies()
        XCTAssertFalse(canAdvance)
    }
    
    func testCanAdvanceAfterLostBattleReset() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            ], battleSize: 3)
        
        // advance all 3 enemies onto the battlefield
        let _ = battle.advanceEnemies() // 1
        let _ = battle.advanceEnemies() // 2
        let _ = battle.advanceEnemies() // 3
        
        // this looses the battle
        let _ = battle.advanceEnemies()
        
        XCTAssertTrue(battle.battleLost)
        battle.takeEnemiesOffBattlefield()
        
        // check can advance again and it's 1 that comes back on first
        let canAdvance = battle.advanceEnemies() // 1
        XCTAssertTrue(canAdvance)
    }
    
    
}
