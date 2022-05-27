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

    func testNewBattleFromValues() throws {
        let battle = try! Battle(armyValues: [1,2,3,4,5])
        XCTAssertTrue(battle.enemies.count == 0)
    }
    
    func testNewBattle() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ])
        XCTAssertTrue(battle.enemies.count == 0)
    }
    
    func testAddEnemy() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ])
        
        let _ = battle.addNextEnemyToBattle()
        XCTAssertTrue(battle.enemies.count == 1, "Should be one enemy on the battlefield")
        XCTAssertTrue(battle.enemies[0].value == 1)
    }
    
    func testAddManyEnemies() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ])
        
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        
        XCTAssertTrue(battle.enemies.count == 3, "Should be three enemies on the battlefield")
        XCTAssertTrue(battle.enemies[0].value == 1)
        XCTAssertTrue(battle.enemies[1].value == 2)
        XCTAssertTrue(battle.enemies[2].value == 3)
    }

    func testShootAndKill() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ])
        
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        
        battle.shoot(value: 2)
        XCTAssertTrue(battle.enemies.count == 2)
        XCTAssertTrue(battle.enemies[0].value == 1)
        XCTAssertTrue(battle.enemies[1].value == 3)
    }
    
    func testShootAndMiss() throws {
        let battle = try! Battle(army: [
            Enemy(value: 1),
            Enemy(value: 2),
            Enemy(value: 3),
            Enemy(value: 4),
            Enemy(value: 5),
            ])
        
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        let _ = battle.addNextEnemyToBattle()
        
        XCTAssertTrue(battle.enemies.count == 3)
        battle.shoot(value: 8)
        XCTAssertTrue(battle.enemies.count == 3)
    }
    
}
