//
//  ScreenTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 28/05/22.
//

import XCTest
@testable import numbermarch

class ScreenTests: XCTestCase {

    func testScreenDisplayCharacter() throws {
        let screen = ScreenNode(numberOfCharacters: 9)
        
        screen.display(.three, screenPosition: 8)
        screen.display(.zero, screenPosition: 9)
        XCTAssertEqual(screen.screenCharacterNodes[7].character, .three)
        XCTAssertEqual(screen.screenCharacterNodes[8].character, .zero)
    }

    func testScreenDisplayCharacters() throws {
        let screen = ScreenNode(numberOfCharacters: 9)
        
        screen.display([DigitalCharacter.three, DigitalCharacter.zero], screenPosition: 9)
        XCTAssertEqual(screen.screenCharacterNodes[7].character, .three)
        XCTAssertEqual(screen.screenCharacterNodes[8].character, .zero)
    }
    
    func testScreenDisplayCharactersWithDecimalPoint() {
        let screen = ScreenNode(numberOfCharacters: 9)
        
        screen.display([DigitalCharacter.three, DigitalCharacter.point, DigitalCharacter.zero], screenPosition: 9)
        XCTAssertEqual(screen.screenCharacterNodes[7].character, .three)
        XCTAssertEqual(screen.decimalPointNodes[7].isHidden, false)
        XCTAssertEqual(screen.screenCharacterNodes[8].character, .zero)
        XCTAssertEqual(screen.decimalPointNodes[8].isHidden, true)
    }
    
    func testScreenDisplayNumberWithDecimalPoint() {
        let screen = ScreenNode(numberOfCharacters: 9)
        
        screen.display(123.45)
        
        // these are all position based (index + 1)
        XCTAssertEqual(screen.characterAt(1), .space)
        XCTAssertEqual(screen.characterAt(2), .space)
        XCTAssertEqual(screen.characterAt(3), .space)
        XCTAssertEqual(screen.characterAt(4), .space)
        XCTAssertEqual(screen.characterAt(5), .one)
        XCTAssertEqual(screen.characterAt(6), .two)
        XCTAssertEqual(screen.characterAt(7), .three)
        XCTAssertEqual(screen.characterAt(8), .four)
        XCTAssertEqual(screen.characterAt(9), .five)
        
        // these are all index based
        XCTAssertEqual(screen.decimalPointNodes[6].isHidden, false)
        XCTAssertEqual(screen.decimalPointNodes[7].isHidden, true)
        XCTAssertEqual(screen.decimalPointNodes[5].isHidden, true)
        XCTAssertEqual(screen.decimalPointNodes[4].isHidden, true)
    }
}
