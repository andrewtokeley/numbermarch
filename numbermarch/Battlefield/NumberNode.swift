//
//  NumberNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 21/05/22.
//

import Foundation
import SpriteKit

/**
 Represents a character that can be displayed on a screen
 */
enum DisplayCharacter: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case mothership = 10
    case threebars = 11
    case twobars = 12
    case onebar = 13
    case space = 14
}

class NumberNode: SKSpriteNode {
    
    /**
     The value of the number node
     */
    var value: Int
    
    /**
     The position of the node on the screen. 0 means the node is not visibile, 1 is the far left position and the maximum depends on the size of the screen
     */
    var screenPosition: Int
    
    /**
     Default initializer
     */
    init(size: CGSize, value: Int = 0, screenPosition: Int = 0) {
        self.value = value
        self.screenPosition = screenPosition
        super.init(texture: nil, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

