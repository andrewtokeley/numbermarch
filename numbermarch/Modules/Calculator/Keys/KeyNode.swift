//
//  KeyNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 30/05/22.
//

import Foundation
import SpriteKit

/**
 Visual representation of a key on the calculator
 */
class KeyNode: SKSpriteNode
{
    private var key: CalculatorKey
    
    init(key: CalculatorKey, size: CGSize = CGSize(width: 50, height: 40)) {
        self.key = key
        super.init(texture: nil, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Child Nodes
    
    private lazy var outerBorder: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size), cornerRadius: 0.1 * self.size.width)
        node.fillColor = .black
        return node
    }()
    
    private lazy var keyPad: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size), cornerRadius: 0.1 * self.size.width)
        node.fillColor = .black
        return node
    }()
}
