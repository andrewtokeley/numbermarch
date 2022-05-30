//
//  NumberNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 21/05/22.
//

import Foundation
import SpriteKit



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

