//
//  SKNodeTests.swift
//  numbermarchTests
//
//  Created by Andrew Tokeley on 3/06/22.
//

import XCTest
import SpriteKit
@testable import numbermarch

class SKNodeTests: XCTestCase {

    
    /**
     Tests that nested SKShapeNodes align properly.
     
     This tests adding a child with an anchor (0, 0) to a parent with an anchor at (0, 0)
     */
    func testAlignSKShapeNodes() throws {
        // Parent 100 x 100
        let parent = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 0)
        parent.lineWidth = 0
        // Child 10 x 10
        let child = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 10, height: 10), cornerRadius: 0)
        child.lineWidth = 0
        
        var position: CGPoint
        
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 45, y: 45))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 45, y: 0))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 45, y: 90))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 0, y: 45))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 0, y: 0))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 0, y: 90))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 90, y: 45))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 90, y: 0))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 90, y: 90))
    }
    
    /**
     Tests that nested SKSpriteNodes align properly.
     
     This tests adding a child with an anchor (0.5, 0.5) to a parent with an anchor at (0.5, 0.5)
     */
    func testAlignSKSpriteNodes() throws {
        // Parent 100 x 100
        let parent = SKSpriteNode(color: .clear, size: CGSize(width: 100, height: 100))

        // Child 10 x 10
        let child = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: 10))
        
        var position: CGPoint
        
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 0, y: 0))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 0, y: -45))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 0, y: 45))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: -45, y: 0))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: -45, y: -45))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: -45, y: 45))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 45, y: 0))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 45, y: -45))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 45, y: 45))
    }
    
    /**
     Tests nesting SKSpriteNodes within ShapeNodes
     
     This tests adding a child with an anchor (0.5, 0.5) to a parent with an anchor at (0, 0)
     */
    func testAlignSpriteNodesInShapNodes() throws {

        // Parent 100 x 100
        let parent = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 100), cornerRadius: 0)
        parent.lineWidth = 0

        // Child 10 x 10
        let child = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: 10))

        var position: CGPoint
        
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 50, y: 50))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 50, y: 5))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 50, y: 95))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 5, y: 50))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 5, y: 5))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .left)
        XCTAssertTrue(position == CGPoint(x: 5, y: 95))
        position = parent.positionForChild(child, verticalAlign: .centre, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 95, y: 50))
        position = parent.positionForChild(child, verticalAlign: .bottom, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 95, y: 5))
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .right)
        XCTAssertTrue(position == CGPoint(x: 95, y: 95))
    }
    
    /**
     Tests nesting nodes inside SKScene
     */
    func testAlignSKScene() throws {
        
        // Scene 100 x 100
        let parent = SKScene(size: CGSize(width: 100, height: 100))
        
        // Child 10 x 10
        let child = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: 10))

        var position: CGPoint
        position = parent.positionForChild(child, verticalAlign: .top, horizontalAlign: .centre)
        XCTAssertTrue(position == CGPoint(x: 50, y: 95))
    }
}
