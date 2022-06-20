//
//  CalculatorDimensionsTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 5/06/22.
//

import XCTest
@testable import numbermarch

class CalculatorDimensionsTests: XCTestCase {

    func testKeyAtCentre() throws {
        
        // this width is the same as the original
        let width: CGFloat = 100
        
        let d = CalculatorDimensions(width: width, originalMeasurements: MG_880_Measurements())
        
        // + button is bottom, right, define with calculator centre being (0, 0)
        let point_plus_middle = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth/2,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight/2
        )
        
        let key = d.keyAt(point_plus_middle)
        
        XCTAssertTrue(key == .plus)
    }
    
    func testKeyAtEdge() throws {
        
        // this width is the same as the original
        let width: CGFloat = 100
        
        let d = CalculatorDimensions(width: width, originalMeasurements: MG_880_Measurements())
        
        // + button is bottom, right, define with calculator centre being (0, 0)
        let point_plus_leftcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight/2
        )
        let point_plus_rightcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight/2
        )
        let point_plus_topcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth/2,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight
        )
        let point_plus_bottomcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth/2,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge
        )
        
        let hit1 = d.keyAt(point_plus_leftcentre)
        let hit2 = d.keyAt(point_plus_rightcentre)
        let hit3 = d.keyAt(point_plus_topcentre)
        let hit4 = d.keyAt(point_plus_bottomcentre)
        
        XCTAssertTrue(hit1 == .plus)
        XCTAssertTrue(hit2 == .plus)
        XCTAssertTrue(hit3 == .plus)
        XCTAssertTrue(hit4 == .plus)
    }

    /**
     The hitzone of a button extends half a button space in all directions
     */
    func testKeyAtOuterEdge() throws {
        
        // this width is the same as the original
        let width: CGFloat = 100
        
        let d = CalculatorDimensions(width: width, originalMeasurements: MG_880_Measurements())
        let bufferHorizontal = d.original.buttonHorizontalDistanceBetween/2 - 1
        let bufferVertical = d.original.buttonVerticalDistanceBetween/2 - 1
        
        // + button is bottom, right, define with calculator centre being (0, 0)
        let point_plus_leftcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - (d.original.buttonWidth + bufferHorizontal),
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight/2
        )
        let point_plus_rightcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge + bufferHorizontal,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight/2
        )
        let point_plus_topcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth/2,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge + d.original.buttonHeight + bufferVertical
        )
        let point_plus_bottomcentre = CGPoint(
            x: d.original.width/2 - d.original.buttonsDistanceFromVerticalEdge - d.original.buttonWidth/2,
            y: -d.original.height/2 + d.original.buttonsDistanceFromBottomEdge - bufferVertical
        )
        
        let hit1 = d.keyAt(point_plus_leftcentre)
        let hit2 = d.keyAt(point_plus_rightcentre)
        let hit3 = d.keyAt(point_plus_topcentre)
        let hit4 = d.keyAt(point_plus_bottomcentre)
        
        XCTAssertTrue(hit1 == .plus)
        XCTAssertTrue(hit2 == .plus)
        XCTAssertTrue(hit3 == .plus)
        XCTAssertTrue(hit4 == .plus)
    }
}
