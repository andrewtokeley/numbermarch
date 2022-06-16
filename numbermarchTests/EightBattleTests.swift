//
//  EightBattleTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 15/06/22.
//

import XCTest
@testable import numbermarch

class EightBattleTests: XCTestCase {

    func testHitWhenAddingMissile() {
        let battle = EightBattle(screenSize: 9)
        battle.readyForNextEnemy() // add an enemy to position 1
        self.advanceEnemy(battle, times: 8) // bring to the end
        if let missileTypeToKill = battle.enemy?.type.canBeKilledByMissleType {
            battle.addMissile(type: missileTypeToKill)
            XCTAssertEqual(battle.enemy?.isDead, true)
        } else {
            XCTFail()
        }
    }
    
    func testMissileHitAndMiss() {
        let battle = EightBattle(screenSize: 9)
        battle.readyForNextEnemy() // add an enemy to position 1
        let _ = battle.advanceEnemy() // move to position 2
        if let enemy = battle.enemy {
            enemy.type = .bottomMissing
            battle.addMissile(type: .top) // position 9
            self.advanceMissile(battle, times: 7) // position 2
                
            XCTAssertEqual(battle.killCount, 0)
            XCTAssertEqual(enemy.isDead, false)
            XCTAssertNil(battle.missile)
            
            // make sure we can still advance the enemy
            let _ = battle.advanceEnemy() // move to position 3
            XCTAssertEqual(battle.enemy?.position, 3)
            
        } else {
            XCTFail()
        }
    }
    
    func testMissileHitAndKill() {
        let battle = EightBattle(screenSize: 9)
        battle.readyForNextEnemy() // add an enemy to position 1
        
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
        battle.readyForNextEnemy() // add an enemy to position 1
        if let enemy = battle.enemy {
            XCTAssertEqual(enemy.isDead, false)
            
            // check it's somewhere on the battlefield
            let position = enemy.position
            XCTAssertTrue(position >= 1)
            XCTAssertTrue(position <= battle.screenSize)
            
            let direction = enemy.direction
            let _ = battle.advanceEnemy()
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
        
        battle.readyForNextEnemy() // add an enemy to position 1
        
        // move to the far right
        self.advanceEnemy(battle, times: 8)
        
        // next move should lose a life
        let _ = battle.advanceEnemy()
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(delegate.method, delegateMethod)

    }
    
    func testBattleStart() throws {
        let battle = EightBattle(screenSize: 9)
        
        XCTAssertNil(battle.enemy)
        XCTAssertNil(battle.missile)
        
    }

    func testMovedPositionFromDelegate() throws {
        let battle = EightBattle(screenSize: 9)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.readyForNextEnemy() // add an enemy to position 1
        let _ = battle.advanceEnemy() // move to 2
        
        let delegateMethod = "movedPositionFrom"
        delegate.createExpectation("testMovedPositionFromDelegate", methodOfInterest: delegateMethod)
        let _ = battle.advanceEnemy() // move to 3
        
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

        battle.readyForNextEnemy() // add an enemy to position 1
        let _ = battle.advanceEnemy() // 2
        let _ = battle.advanceEnemy() // 3
        battle.addMissile(type: .middle) // 9
        let _ = battle.advanceMissile() // 8
        
        let delegateMethod = "missileMovedPositionFrom"
        delegate.createExpectation("testMissileMovedPositionFromDelegate", methodOfInterest: delegateMethod)
        let _ = battle.advanceMissile() // 7
        
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

        battle.readyForNextEnemy() // adds enemy to 1
        let _ = battle.advanceEnemy() // 2
        let _ = battle.advanceEnemy() // 3
        XCTAssertEqual(battle.enemy?.position, 3)
        
        // prepare a missile that will kill
        if let missileType = battle.enemy?.type.canBeKilledByMissleType {
            battle.addMissile(type: missileType) // 9
            self.advanceMissile(battle, times: 5)
            XCTAssertEqual(battle.missile?.position, 4)
        } else {
            XCTFail()
        }
        
//        let delegateMethod = "enemyKilled"
//        delegate.createExpectation("testEnemyKilledDelegate", methodOfInterest: delegateMethod)
//        let _ = battle.advanceMissile() // 3 - this should cause a hit and match
//
//        // wait until the delegate fires
//        self.waitForExpectations(timeout: 5, handler: nil)
//
//        // Test delegate method called with right parameters
//        XCTAssertEqual(delegate.method, "enemyKilled")
//        XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.position, 3)
    }
    
    private func advanceEnemy(_ battle: EightBattle, times: Int) {
        for _ in 1...times {
            let _ = battle.advanceEnemy()
        }
    }
    
    private func advanceMissile(_ battle: EightBattle, times: Int) {
        for _ in 1...times {
            let _ = battle.advanceMissile()
        }
    }
}


// MARK: - MockEightBattleDelegate

class MockEightBattleDelegate: EightBattleDelegate {
    
    var method: String?
    var parameters = [Any]()
    var methodOfInterest: String?
    
    func battleWon(_ battle: EightBattle) {
        guard methodOfInterest == "battleWon" else { return }
        
        method = "battleWon"
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, removeEnemy enemy: EightEnemy) {
        guard methodOfInterest == "removeEnemy" else { return }
        
        method = "removeEnemy"
        parameters.append(enemy)
        fulfillExpectation()
    }
    
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
