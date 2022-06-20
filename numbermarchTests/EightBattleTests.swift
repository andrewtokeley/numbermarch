//
//  EightBattleTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 15/06/22.
//

import XCTest
@testable import numbermarch

class EightBattleTests: XCTestCase {

    var rules = ClassicEightAttackRules()
    
//    func testEnenyChange() throws {
//        let battle = EightBattle(screenSize: 9, rules: self.rules)
//        battle.readyToStartGame()
//        battle.readyForNextLevel() // add an enemy to position 1, moving right
//
//        if let enemy = battle.enemy {
//            let originalType = enemy.type
//
//            // should change yet
//            XCTAssertEqual(rules.shouldChangeEnemyShape(level: battle.level, enemyDistanceFromStart: battle.enemyDistanceFromStart(enemy)), false)
//
//            let _ = battle.advanceEnemy() // 2
//            let _ = battle.advanceEnemy() // 3
//
//            // mock rules say should change after a distance is 4 is reached
//            let _ = battle.advanceEnemy() // 4
//            XCTAssertEqual(rules.shouldChangeEnemyShape(level: battle.level, enemyDistanceFromStart: battle.enemyDistanceFromStart(enemy)), true)
//
//            let _ = battle.advanceEnemy() // 5
//            XCTAssertNotEqual(originalType, enemy.type)
//            XCTAssertEqual(rules.shouldChangeEnemyShape(level: battle.level, enemyDistanceFromStart: battle.enemyDistanceFromStart(enemy)), false)
//
//
//        } else {
//            XCTFail()
//        }
//
//    }
    
    func testEnemyToggle() throws {
        // Create a battle with enemies changing alternative steps
        let battle = EightBattle(screenSize: 9, rules: MockRulesWithToggle())
    
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1, moving right
        
        let type1 = battle.enemy?.type
        let _ = battle.advanceEnemy()
        let type2 = battle.enemy?.type
        
        // first two types different
        XCTAssertNotEqual(type1, type2)
        
        // then we're back to the first
        let _ = battle.advanceEnemy()
        XCTAssertEqual(battle.enemy?.type, type1)
    }
    
    func testCanKillAfterEnemyChanges() throws {
        // Create a battle with enemies changing alternative steps
        let battle = EightBattle(screenSize: 9, rules: MockRulesWithToggle())

        battle.readyToStartGame()
        battle.readyForNextLevel() // position 1, type 1

        if let enemy = battle.enemy {

            // mock rules have all levels toggling
            XCTAssertEqual(rules.shouldToggleEnemyType(level: 1), true)

            let _ = battle.advanceEnemy() // 2, type 2
            
            let _ = battle.advanceEnemy() // 5 - Mock rules so it will have changed here

            // get ready to kill the changed enemy
            battle.addMissile(type: enemy.type.canBeKilledByMissleType)
            advanceMissile(battle, times: 4) // 9 to 5

            // enemy should be dead
            XCTAssertEqual(enemy.isDead, true)

        } else {
            XCTFail()
        }

    }

//    func testCanKillAfterEnemyChanges_WithDelegate() throws {
//        let battle = EightBattle(screenSize: 9, rules: self.rules)
//        let delegate = MockEightBattleDelegate(self)
//        battle.delegate = delegate
//        battle.readyToStartGame()
//        battle.readyForNextLevel() // add an enemy to position 1
//
//        if let enemy = battle.enemy {
//            let originalType = enemy.type
//            let _ = battle.advanceEnemy() // 2
//            let _ = battle.advanceEnemy() // 3
//            let _ = battle.advanceEnemy() // 4
//            let _ = battle.advanceEnemy() // 5 // will have changed type
//            battle.addMissile(type: enemy.type.canBeKilledByMissleType) // 9
//
//            let delegateMethod = "enemyKilled"
//            delegate.createExpectation("testCanKillAfterEnemyChanges_WithDelegate", methodOfInterest: delegateMethod)
//
//            // this should kill the enemy and call the delegate method
//            let _ = self.advanceMissile(battle, times: 4) // move from 9 to 5
//
//            // wait until the delegate fires
//            self.waitForExpectations(timeout: 5, handler: nil)
//
//            XCTAssertEqual(delegate.method, delegateMethod)
//
//            // test that the enemy killed doesn't have the same type as original
//            XCTAssertNotEqual((delegate.parameters[0] as? EightEnemy)?.type, originalType)
//
//        } else {
//            XCTFail()
//        }
//    }
//
//    func testCanKillJUSTBeforeEnemyChanges_WithDelegate() throws {
//        let battle = EightBattle(screenSize: 9, rules: self.rules)
//        let delegate = MockEightBattleDelegate(self)
//        battle.delegate = delegate
//        battle.readyToStartGame()
//        battle.readyForNextLevel() // add an enemy to position 1
//
//        if let enemy = battle.enemy {
//            let originalType = enemy.type
//
//            let _ = battle.advanceEnemy() // 2
//            let _ = battle.advanceEnemy() // 3
//            let _ = battle.advanceEnemy() // 4
//            XCTAssertEqual(battle.enemy?.type, originalType)
//
//            // won't have changed yet, but is one move from changing
//
//            let delegateMethod = "enemyKilled"
//            delegate.createExpectation("testCanKillJUSTBeforeEnemyChanges_WithDelegate", methodOfInterest: delegateMethod)
//
//            // this should kill the enemy based on it's original type
//            battle.addMissile(type: originalType.canBeKilledByMissleType) // 9
//            let _ = self.advanceMissile(battle, times: 5) // move from 9 to 4
//
//            // wait until the delegate fires
//            self.waitForExpectations(timeout: 5, handler: nil)
//
//            XCTAssertEqual(delegate.method, delegateMethod)
//
//            // test kill
////            XCTAssertEqual(battle.enemy?.isDead, true)
////            XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.isDead, true)
////            XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.position, 4)
////            XCTAssertEqual((delegate.parameters[0] as? EightEnemy)?.type, originalType)
//
//        } else {
//            XCTFail()
//        }
//    }
//
    func testEightEnemyTypeNot() throws {
        let type = EightEnemyType.bottomMissing
        XCTAssertNotEqual(type, type.not())
    }
    
    func testDistanceFromStart_MovingRight() throws {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1, moving right
        if let enemy = battle.enemy {
            XCTAssertEqual(battle.enemyDistanceFromStart(enemy), 1)
            
            let _ = battle.advanceEnemy() // 2
            XCTAssertEqual(battle.enemyDistanceFromStart(enemy), 2)
            
            let _ = battle.advanceEnemy() // 3
            XCTAssertEqual(battle.enemyDistanceFromStart(enemy), 3)
        } else {
            XCTFail()
        }
    }
    
    func testHitWhenAddingMissile() {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        self.advanceEnemy(battle, times: 8) // bring to the end
        if let missileTypeToKill = battle.enemy?.type.canBeKilledByMissleType {
            battle.addMissile(type: missileTypeToKill)
            XCTAssertEqual(battle.enemy?.isDead, true)
        } else {
            XCTFail()
        }
    }
    
    func testMissileHitAndMiss() {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        let _ = battle.advanceEnemy() // move to position 2
        if let enemy = battle.enemy {
            enemy.type = .bottomMissing
            battle.addMissile(type: .top) // position 9
            self.advanceMissile(battle, times: 7) // position 2
                
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
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        
        if let enemy = battle.enemy {
            let missileType = enemy.type.canBeKilledByMissleType
            battle.addMissile(type: missileType)
            self.advanceMissile(battle, times: 8) // 8th move shoud hit the enemy and kill
            
            XCTAssertEqual(enemy.isDead, true)
            XCTAssertNil(battle.missile)
        } else {
            XCTFail()
        }
    }
    
    func testAddMoveEnemy() {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
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
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        let delegateMethod = "lostLife"
        delegate.createExpectation("testLoseLife", methodOfInterest: delegateMethod)
        
        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        
        // move to the far right
        self.advanceEnemy(battle, times: 8)
        
        // next move should lose a life
        let _ = battle.advanceEnemy()
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(delegate.method, delegateMethod)
        XCTAssertEqual(delegate.parameters[0] as? Int, rules.numberOfLives - 1)
    }
    
    func testBattleStart() throws {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        
        XCTAssertNil(battle.enemy)
        XCTAssertNil(battle.missile)
        
    }

    func testMovedPositionFromDelegate() throws {
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        
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
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        
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
        let battle = EightBattle(screenSize: 9, rules: self.rules)
        let delegate = MockEightBattleDelegate(self)
        battle.delegate = delegate

        battle.readyToStartGame()
        battle.readyForNextLevel() // add an enemy to position 1
        
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
    
//    func eightBattle(_ battle: EightBattle, enemyChangedType type: EightEnemyType, position: Int) {
//        //
//    }
    
    func eightBattle(_ battle: EightBattle, lostLife livesLeft: Int) {
        guard methodOfInterest == "lostLife" else { return }
        
        method = "lostLife"
        parameters.append(livesLeft)
        fulfillExpectation()
    }
    
    func eightBattle(_ battle: EightBattle, gainedLife livesGained: Int) {
        //
    }
    
    func battleGameOver(_ battle: EightBattle) {
        //
    }
    
    func eightBattle(_ battle: EightBattle, newLevel: Int, score: Int) {
        //
    }
    
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

class MockRulesWithToggle: ClassicEightAttackRules {
    override func shouldToggleEnemyType(level: Int) -> Bool {
        return true
    }
}

