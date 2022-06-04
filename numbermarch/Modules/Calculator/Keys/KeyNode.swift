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
    private let KEYPAD_OFFSET: CGFloat = 1
    
    private var keyColor: UIColor
    
    private var WIDTH: CGFloat {
        return self.frame.width
    }
    
    private var HEIGHT: CGFloat {
        return self.frame.height
    }
    
    init(key: CalculatorKey, keyColor: UIColor = .darkGray, size: CGSize = CGSize(width: 50, height: 40)) {
        self.key = key
        self.keyColor = keyColor
        super.init(texture: nil, color: .blue, size: size)
        
        self.addChild(self.outerBorder, verticalAlign: .centre, horizontalAlign: .centre)
        self.outerBorder.addChild(self.keyPad, verticalAlign: .centre, horizontalAlign: .centre, offSet: CGVector(dx: -KEYPAD_OFFSET, dy: -KEYPAD_OFFSET))
        self.keyPad.addChild(self.character, verticalAlign: .centre, horizontalAlign: .centre)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Child Nodes
    
    private lazy var outerBorder: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size), cornerRadius: 0.1 * self.size.width)
        node.fillColor = .black
        node.strokeColor = .black
        return node
    }()
    
    private lazy var keyPad: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.size.width - 4, height: self.size.height - 4)), cornerRadius: 0.1 * self.size.width)
        node.fillColor = self.keyColor
        node.strokeColor = .lightGray
        
        // test
        let keypress = SKAction.sequence([pressed, delay, released, delay])
        node.run(SKAction.repeatForever(keypress))
        return node
    }()
    
    private lazy var keyPadInner: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 10, height: 10)), cornerRadius: 0.1 * self.size.width)
        node.fillColor = .blue
        return node
    }()
    
    private lazy var character: SKLabelNode = {
        let node = SKLabelNode(text: self.key.asText())
        node.fontColor = UIColor.white
        node.fontName = "Arial Bold"
        node.fontSize = 20
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        return node
    }()
    
    // MARK: - Actions
    
    private var delay: SKAction {
        let action = SKAction.wait(forDuration: TimeInterval(1))
        return action
    }
    
    private var pressed: SKAction {
        let action = SKAction.move(by: CGVector(dx: KEYPAD_OFFSET, dy: KEYPAD_OFFSET), duration: TimeInterval(0.1))
        return action
    }
    
    private var released: SKAction {
        let action = SKAction.move(by: CGVector(dx: -KEYPAD_OFFSET, dy: -KEYPAD_OFFSET), duration: TimeInterval(0.1))
        return action
    }
    
    
}
