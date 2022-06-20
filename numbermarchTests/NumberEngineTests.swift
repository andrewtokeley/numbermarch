//
//  NumberEngineTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 20/06/22.
//

import XCTest
@testable import numbermarch

class NumberEngineTests: XCTestCase {

    func testEnteringMultipleDigits() throws {
        
        let engine = NumberEngine(screen: ScreenNode(numberOfCharacters: 9))
        engine.keyPressed(key: .one)
        engine.keyPressed(key: .two)
        engine.keyPressed(key: .three)
        
        XCTAssertEqual(engine.screen.asNumber, 123)
    }

    func testCalculatorEngineEnteringMultipleDigits() throws {
        
        let engine = CalculatorEngine(screen: ScreenNode(numberOfCharacters: 8))
        engine.keyPressed(key: .one)
        engine.keyPressed(key: .two)
        engine.keyPressed(key: .three)
        
        XCTAssertEqual(engine.screen.asNumber, 123)
    }
    
    func testEnteringMultipleDigitsSmallScreen() throws {
        
        let engine = NumberEngine(screen: ScreenNode(numberOfCharacters: 8))
        engine.keyPressed(key: .one)
        engine.keyPressed(key: .two)
        engine.keyPressed(key: .three)
        
        XCTAssertEqual(engine.screen.asNumber, 123)
    }
    
    func testEnteringTooManyDigits() throws {
        
        let engine = NumberEngine(screen: ScreenNode(numberOfCharacters: 5))
        engine.keyPressed(key: .one)
        engine.keyPressed(key: .two)
        engine.keyPressed(key: .three)
        engine.keyPressed(key: .four)
        engine.keyPressed(key: .five)
        
        XCTAssertEqual(engine.screen.asNumber, 12345)
        
        engine.keyPressed(key: .six) // should be ignored
        XCTAssertEqual(engine.screen.asNumber, 12345)
    }
}

