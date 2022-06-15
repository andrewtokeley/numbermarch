//
//  ExpressionBuilderTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 14/06/22.
//

import XCTest
@testable import numbermarch

class ExpressionBuilderTests: XCTestCase {

    func testAddingMultipleSameOperator() throws {
        let builder = ExpressionBuilder()
        builder.add(.one)
        builder.add(.times)
        builder.add(.times)
        builder.add(.two)
        
        XCTAssertEqual(builder.expression, "1*2")
    }
    
    func testReplacingLastOperator() throws {
        let builder = ExpressionBuilder()
        builder.add(.one)
        builder.add(.times)
        builder.add(.divide)
        builder.add(.two)
        
        XCTAssertEqual(builder.expression, "1/2")
    }

    func testExpressionStartingWithIllegal() throws {
        let builder = ExpressionBuilder()
        builder.add(.times)
        builder.add(.two)
        XCTAssertEqual(builder.expression, "2")
        
        builder.allClear()
        builder.add(.divide)
        XCTAssertEqual(builder.expression, "")
        
        builder.allClear()
        builder.add(.plus)
        builder.add(.three)
        XCTAssertEqual(builder.expression, "+3")
        
        builder.allClear()
        builder.add(.minus)
        builder.add(.five)
        XCTAssertEqual(builder.expression, "-5")
    }
    
    func testAddMinus() throws {
        let builder = ExpressionBuilder()
        builder.add(.one)
        builder.add(.plus)
        builder.add(.minus)
        builder.add(.one)
        XCTAssertEqual(builder.expression, "1+-1")
    }
    
    func testClear() throws {
        let builder = ExpressionBuilder()
        builder.add(.one)
        builder.add(.plus)
        builder.add(.two)
        builder.clear()
        builder.add(.three)
        XCTAssertEqual(builder.expression, "1+3")
    }
    
    func testAddingDecimal() throws {
        let builder = ExpressionBuilder()
        builder.add(.one)
        builder.add(.point)
        builder.add(.two)
        XCTAssertEqual(builder.expression, "1.2")
    }
    
    func testAddNumber() throws {
        let builder = ExpressionBuilder()
        builder.addNumber(12.3)
        XCTAssertEqual(builder.expression, "12.3")
    }
}
