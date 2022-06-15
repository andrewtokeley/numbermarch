//
//  EightBattleTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 15/06/22.
//

import XCTest
@testable import numbermarch

class EightBattleTests: XCTestCase {

    func testMissileHitAndMiss() {
        let battle = EightBattle(screenSize: 9)
        battle.initialiseGame() // should add an enemy to position 1
        
        if let enemy = battle.enemy {
            let missileType = EightMissilleTypeEnum.not(enemy.type.canBeKilledByMissleType)
            battle.addMissile(type: missileType)
            self.advanceMissile(battle, times: 8) // 8th move shoud hit the enemy but not kill
                
            XCTAssertEqual(battle.killCount, 0)
            XCTAssertEqual(enemy.isDead, false)
            XCTAssertNil(battle.missile)
        } else {
            XCTFail()
        }
    }
    
    func testMissileHitAndKill() {
        let battle = EightBattle(screenSize: 9)
        battle.initialiseGame() // should add an enemy to position 1
        XCTAssertEqual(battle.killCount, 0)
        
        if let enemy = battle.enemy {
            let missileType = enemy.type.canBeKilledByMissleType
            battle.addMissile(type: missileType)
            self.advanceMissile(battle, times: 8) // 8th move shoud hit the enemy but kill
            
            XCTAssertEqual(battle.killCount, 1)
            XCTAssertNil(battle.missile)
        } else {
            XCTFail()
        }
    }
    
    func testAddMoveEnemy() {
        let battle = EightBattle(screenSize: 9)
        battle.initialiseGame() // should add an enemy
        if let enemy = battle.enemy {
            XCTAssertEqual(enemy.isDead, false)
            
            // check it's somewhere on the battlefield
            let position = enemy.position
            XCTAssertTrue(position >= 1)
            XCTAssertTrue(position <= battle.screenSize)
            
            let direction = enemy.direction
            battle.advanceEnemy()
            XCTAssertEqual(enemy.position, position + direction.rawValue)
        }
    }
    
    
    // MARK: - Delegate Tests
    
    func testLoseLife() {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        let delegateMethod = "battleLost"
        delegate.createExpectation("testLoseLife", methodOfInterest: delegateMethod)
        
        battle.initialiseGame() // should add an enemy to position 1
        
        // move to the far right
        self.advanceEnemy(battle, times: 8)
        
        // next move should lose a life
        battle.advanceEnemy()
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(delegate.method, delegateMethod)

    }
    
    func testBattleStart() throws {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        let delegateMethod = "addEnemy"
        delegate.createExpectation("testBattleStart", methodOfInterest: delegateMethod)
        battle.initialiseGame()
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(delegate.method, delegateMethod)
        let enemy = delegate.parameters[0] as? EightEnemy
        XCTAssertNotNil(enemy)
        
        // Games always start on the left side of screen
        XCTAssertEqual(enemy?.position, 1)
        XCTAssertEqual(enemy?.direction, .right)
        
        XCTAssertEqual(battle.screenSize, 9)
        XCTAssertEqual(battle.numberOfExplodedBombs, 0)
        
    }

    func testMovedPositionFromDelegate() throws {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.initialiseGame() // start at position 1
        battle.advanceEnemy() // move to 2
        
        let delegateMethod = "movedPositionFrom"
        delegate.createExpectation("testMovedPositionFromDelegate", methodOfInterest: delegateMethod)
        battle.advanceEnemy() // move to 3
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        // Test delegate method called with right parameters
        XCTAssertEqual(delegate.method, delegateMethod)
        XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.position, 3)
        XCTAssertEqual(delegate.parameters[1] as? Int, 2) // From
        XCTAssertEqual(delegate.parameters[2] as? Int, 3) // To
    }
    
    func testMissileMovedPositionFromDelegate() throws {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.initialiseGame() // start at position 1
        battle.advanceEnemy() // 2
        battle.advanceEnemy() // 3
        battle.addMissile(type: .middle) // 9
        battle.advanceMissile() // 8
        
        let delegateMethod = "missileMovedPositionFrom"
        delegate.createExpectation("testMissileMovedPositionFromDelegate", methodOfInterest: delegateMethod)
        battle.advanceMissile() // 7
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        // Test delegate method called with right parameters
        XCTAssertEqual(delegate.method, "missileMovedPositionFrom")
        XCTAssertEqual((delegate.parameters[0] as? EightMissile)?.position, 7)
        XCTAssertEqual(delegate.parameters[1] as? Int, 8) // From
        XCTAssertEqual(delegate.parameters[2] as? Int, 7) // To
    }
    
    func testEnemyKilledDelegate() throws {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.initialiseGame() // start at position 1, moving right
        battle.advanceEnemy() // 2
        battle.advanceEnemy() // 3
        XCTAssertEqual(battle.enemy?.position, 3)
        
        // prepare a missile that will kill
        battle.addMissile(type: battle.enemy!.type.canBeKilledByMissleType) // 9
        battle.advanceMissile() // 8
        battle.advanceMissile() // 7
        battle.advanceMissile() // 6
        battle.advanceMissile() // 5
        battle.advanceMissile() // 4
        XCTAssertEqual(battle.missile?.position, 4)
        
        let delegateMethod = "enemyKilled"
        delegate.createExpectation("testEnemyKilledDelegate", methodOfInterest: delegateMethod)
        battle.advanceMissile() // 3 - this should cause a hit and match

        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)

        // Test delegate method called with right parameters
        XCTAssertEqual(delegate.method, "enemyKilled")
        XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.position, 3)
    }
    
    private func advanceEnemy(_ battle: EightBattle, times: Int) {
        for _ in 1...times {
            battle.advanceEnemy()
        }
    }
    
    private func advanceMissile(_ battle: EightBattle, times: Int) {
        for _ in 1...times {
            battle.advanceMissile()
        }
    }
}


// MARK: - MockEightBattleDelegate

class MockEightBattleDelegate: EightBattleDelegate {
    
    var method: String?
    var parameters = [Any]()
    var methodOfInterest: String?
    
    func battleLost(_ battle: EightBattle) {
        guard methodOfInterest == "battleLost" else { return }
        
        method = "battleLost"
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, addEnemy enemy: EightEnemy, position: Int) {
        guard methodOfInterest == "addEnemy" else { return }
        
        method = "addEnemy"
        parameters.append(enemy)
        parameters.append(position)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, enemy: EightEnemy, movedPositionFrom from: Int, to: Int) {
        guard methodOfInterest == "movedPositionFrom" else { return }
        
        method = "movedPositionFrom"
        parameters.append(enemy)
        parameters.append(from)
        parameters.append(to)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, enemyKilled: EightEnemy) {
        guard methodOfInterest == "enemyKilled" else { return }
        
        method = "enemyKilled"
        parameters.append(enemyKilled)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, bombsCreated bombs: [EightBomb]) {
        guard methodOfInterest == "bombsCreated" else { return }

        method = "bombsCreated"
        parameters.append(bombs)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, bombExploded bomb: EightBomb) {
        guard methodOfInterest == "bombsExploded" else { return }
        
        method = "bombsExploded"
        parameters.append(bomb)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, missile: EightMissile, movedPositionFrom from: Int, to: Int) {
        guard methodOfInterest == "missileMovedPositionFrom" else { return }
        
        method = "missileMovedPositionFrom"
        parameters.append(missile)
        parameters.append(from)
        parameters.append(to)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, removeMissile missile: EightMissile) {
        guard methodOfInterest == "removeMissile" else { return }
        
        method = "removeMissile"
        parameters.append(missile)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, addMissile missile: EightMissile, position: Int) {
        guard methodOfInterest == "missileLaunchedFromPosition" else { return }
        
        method = "missileLaunchedFromPosition"
        parameters.append(missile)
        parameters.append(position)
        fulfillExpectation()
    }
    
    var testCase: XCTestCase
    var expectation: XCTestExpectation?

    init(_ testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    public func createExpectation(_ description: String, methodOfInterest method: String) {
        self.methodOfInterest = method
        self.method = ""
        self.parameters = [Any]()
        self.expectation = testCase.expectation(description: description)
    }
    
    private func fulfillExpectation() {
        self.expectation?.fulfill()
        self.expectation = nil
    }
    
}
