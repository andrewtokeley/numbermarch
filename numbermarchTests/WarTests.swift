//
//  WarTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 16/05/22.
//

import XCTest
@testable import numbermarch

class WarTests: XCTestCase {
    
    var warService: WarServiceInterface = WarFactory.sharedInstance.warService
    
    func testWarBattleSpeeds() throws {
            
        let rules = DigitalInvadersClassicRules()
        
        XCTAssertEqual(rules.stepTimeInterval(level: 1), rules.stepTimeInterval(level: 10))
        XCTAssertEqual(rules.stepTimeInterval(level: 2), rules.stepTimeInterval(level: 11))
        XCTAssertEqual(rules.stepTimeInterval(level: 3), rules.stepTimeInterval(level: 12))
        XCTAssertEqual(rules.stepTimeInterval(level: 4), rules.stepTimeInterval(level: 13))
        XCTAssertEqual(rules.stepTimeInterval(level: 5), rules.stepTimeInterval(level: 14))
        XCTAssertEqual(rules.stepTimeInterval(level: 6), rules.stepTimeInterval(level: 15))
        XCTAssertEqual(rules.stepTimeInterval(level: 7), rules.stepTimeInterval(level: 16))
        XCTAssertEqual(rules.stepTimeInterval(level: 8), rules.stepTimeInterval(level: 17))
        XCTAssertEqual(rules.stepTimeInterval(level: 9), rules.stepTimeInterval(level: 18))
        
    }
    
    func testBattleFieldSize() throws {
        let rules = DigitalInvadersClassicRules()
        
        warService.createWar(rules: rules) { war, error in
            XCTAssertNil(error)
            
            // SpaceInvader rules have battle size at 6 until the 10th battle when it changes to 5
            
            // Creating a war schedules the first battle...
            XCTAssertTrue(war.battle?.battleSize == 6)
            XCTAssertTrue(war.battle?.battlefield.count == 6)
            
            let _ = war.moveToNextBattle() // 2
            let _ = war.moveToNextBattle() // 3
            let _ = war.moveToNextBattle() // 4
            let _ = war.moveToNextBattle() // 5
            let _ = war.moveToNextBattle() // 6
            let _ = war.moveToNextBattle() // 7
            let _ = war.moveToNextBattle() // 8
            let _ = war.moveToNextBattle() // 9
            XCTAssertEqual(war.battle?.battleSize, 6)
            XCTAssertEqual(war.battle?.battlefield.count, 6)
            
            let _ = war.moveToNextBattle() // 10
            let _ = war.moveToNextBattle() // 11
            XCTAssertEqual(war.battle?.battleSize, 5)
            XCTAssertEqual(war.battle?.battlefield.count, 5)
            
        }
    }
    
    func testBattleSize() throws {
        let rules = DigitalInvadersClassicRules()
        
        warService.createWar(rules: rules) { war, error in
            XCTAssertNil(error)
            
            // SpaceInvader rules have battle size at 6 until the 10th battle when it changes to 5
            
            // Creating a war schedules the first battle...
            XCTAssertTrue(war.battle?.battleSize == 6)
            XCTAssertTrue(war.battle?.level == 1)
            
            let _ = war.moveToNextBattle() // 2
            let _ = war.moveToNextBattle() // 3
            let _ = war.moveToNextBattle() // 4
            let _ = war.moveToNextBattle() // 5
            XCTAssertTrue(war.battle?.battleSize == 6)
            XCTAssertTrue(war.battle?.level == 5)
            let _ = war.moveToNextBattle() // 6
            let _ = war.moveToNextBattle() // 7
            let _ = war.moveToNextBattle() // 8
            let _ = war.moveToNextBattle() // 9
            XCTAssertTrue(war.battle?.battleSize == 6)
            
            let _ = war.moveToNextBattle() // first level in the second wave, battlefield now 5
            XCTAssertTrue(war.battle?.battleSize == 5)
            let _ = war.moveToNextBattle() // 10
            let _ = war.moveToNextBattle() // 11
            // still 5?
            XCTAssertTrue(war.battle?.battleSize == 5) // 10
        }
    }
    
    func testScoreLevel() throws {
        let rules = DigitalInvadersClassicRules()
        
        let enemy = Enemy(value: 3)
        
        // max points for levels up to 9, note that index is 0 based
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 1, position: 6) == 60)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 2, position: 6) == 60)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 3, position: 6) == 60)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 9, position: 6) == 60)

        // when we get to level 10 - 18 the max is 100, but enemies start at position 5, so
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 10, position: 6) == 0)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 10, position: 5) == 100)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 12, position: 5) == 100)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 17, position: 5) == 100)

        // test a few more
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 1, position: 3) == 30)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 9, position: 4) == 40)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 10, position: 2) == 40)
        XCTAssertTrue(rules.pointsForKillingEnemy(enemy: enemy, level: 17, position: 1) == 20)
    }
    
    func testWarCreatesCorrectNumberOfBattles() throws {
        let expectation = self.expectation(description: "testWarCreatesCorrectNumberOfBattles")
        var newWar: War?
        
        let rules = DigitalInvadersClassicRules()
        
        warService.createWar(rules: rules) { war, error in
            newWar = war
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(newWar?.numberOfBattles, rules.numberOfLevels)
    }
    
    func testWarScore() throws {
        let expectation = self.expectation(description: "testWarCreatesCorrectNumberOfBattles")
        var newWar: War?
        
        let rules = DigitalInvadersClassicRules()
        
        let battle1 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle1.score = 11
        let battle2 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle2.score = 21
        let battle3 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle3.score = 31
        
        warService.createWar(battles: [battle1, battle2, battle3], rules: rules) { war, error in
            newWar = war
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(newWar?.score, 63)
    }
    
    func testWarWonScoreViaDelegate() {
        
        var newWar: War?
        
        let rules = DigitalInvadersClassicRules()
        
        let battle1 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle1.score = 11
        let battle2 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle2.score = 21
        let battle3 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle3.score = 31
        
        let delegate = MockWarDelegate(self)
        let expectation = self.expectation(description: "createWarExpectation")
        warService.createWar(battles: [battle1, battle2, battle3], rules: rules) { war, error in
            newWar = war
            newWar?.delegate = delegate
            expectation.fulfill()
        }
        // wait for the war to be created
        self.waitForExpectations(timeout: 5, handler: nil)
        
        // war has been created now let's test whether the delegate is called when we've moved through all the battles
        
        delegate.createExpectation()
        XCTAssertEqual(delegate.warWonWithScore, 0)
        
        let _ = newWar?.moveToNextBattle() // ok
        let _ = newWar?.moveToNextBattle() // ok
        let _ = newWar?.moveToNextBattle() // ok
        let _ = newWar?.moveToNextBattle() // this should trigger the delegate
        
        // wait until the delegate fires
        self.waitForExpectations(timeout: 5, handler: nil)
        
        // if the warWonWithScore property is set we know the delegate was called successfully
        XCTAssertEqual(delegate.warWonWithScore, 63)
    }
    
    func testLevelAfterNewBattle() {
        var newWar: War?
        
        let rules = DigitalInvadersClassicRules()
        
        let battle1 = try! Battle(armyValues: [1,2,3], level: 1, rules: rules, delegate: nil)
        battle1.score = 11
        let battle2 = try! Battle(armyValues: [1,2,3], level: 2, rules: rules, delegate: nil)
        battle2.score = 21
        let battle3 = try! Battle(armyValues: [1,2,3], level: 3, rules: rules, delegate: nil)
        battle3.score = 31
        
        let delegate = MockWarDelegate(self)
        let expectation = self.expectation(description: "createWarExpectation")
        warService.createWar(battles: [battle1, battle2, battle3], rules: rules) { war, error in
            newWar = war
            newWar?.delegate = delegate
            expectation.fulfill()
        }
        // wait for the war to be created
        self.waitForExpectations(timeout: 5, handler: nil)
        
        delegate.createExpectation()
        try! newWar?.startWar()
        self.waitForExpectations(timeout: 5, handler: nil)
        
        // startWar should trigger the first battle at level 1
        XCTAssertEqual(delegate.newBattle?.level, 1)
        
        delegate.createExpectation()
        let _ = newWar?.moveToNextBattle()
        self.waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(delegate.newBattle?.level, 2)
    }
}

class MockWarDelegate: WarDelegate {
    
    var testCase: XCTestCase
    var expectation: XCTestExpectation?
    
    var warWonWithScore: Int = 0
    var newBattle: Battle? = nil
    
    init(_ testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    public func createExpectation() {
        self.expectation = testCase.expectation(description: "warWonExpectation")
    }
    
    private func fulfillExpectation() {
        self.expectation?.fulfill()
        self.expectation = nil
    }
    
    func war(_ war: War, newBattle battle: Battle) {
        newBattle = battle
        self.fulfillExpectation()
    }
    
    func war(_ war: War, warWonWithScore score: Int) {
        warWonWithScore = score
        self.fulfillExpectation()
    }
}

