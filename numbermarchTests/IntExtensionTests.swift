//
//  TestIntExtension.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 16/06/22.
//

import XCTest
@testable import numbermarch

class IntExtensionTests: XCTestCase {

    
    func testInclusive() throws {
        let x = 3
        XCTAssertTrue(x.isBetween(0, 3, true))
    }

    func testExclusive() throws {
        let x = 3
        XCTAssertFalse(x.isBetween(0, 3))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
