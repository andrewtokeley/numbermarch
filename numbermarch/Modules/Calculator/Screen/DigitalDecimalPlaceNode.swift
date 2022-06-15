//
//  DigitalDecimalPlaceNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 9/06/22.
//

import Foundation
import SpriteKit

class DigitalDecimalPointNode: SKSpriteNode {
    
    // MARK: - Private Properties
    
    /**
     The thickness of the decimal point as a proportion of it's width
     
     This is a similar concept to the barThickness propery on the ``DigitalCharacterNode`` to ensure the character looks good regardless of the size of its frame
     */
    private var barThickness: CGFloat {
        return self.size.width/3
    }
    
    /// Colour of bar borders
    private var barStroke: UIColor = UIColor.gameBattlefieldText
    
    /// Colour of bar fill
    private var barFill: UIColor = UIColor.gameBattlefieldText
    
    // MARK: - Initialisers
    
    init(size: CGSize = CGSize(width: 6, height: 40)) {
        super.init(texture: nil, color: .clear, size: size)
        self.addChild(decimalPoint, verticalAlign: .bottom, horizontalAlign: .centre)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Child Nodes
    
    /**
     Decimal point node to be rendered in the middle bottom of the node's frame
     */
    private lazy var decimalPoint: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x:0, y:0, width: self.barThickness, height: self.barThickness))
        node.fillColor = self.barFill
        node.lineWidth = 0
        return node
    }()
}
