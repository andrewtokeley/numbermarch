//
//  OperationNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 22/06/22.
//

import Foundation
import SpriteKit

enum OperationSymbol: Int {
    case add = 0
    case substract
    case multiply
    case divide
    
    var asText: String {
        switch self {
        case .add:
            return "+"
        case .substract:
            return "-"
        case .multiply:
            return "÷"
        case .divide:
            return "x"
        }
    }
}

class OperationNode: SKSpriteNode {
    // MARK: - Public Properties
    public var fillColour: UIColor
    
    public var fontColour: UIColor
    
    public var operationSymbol: OperationSymbol
    
    //public var size: CGSize
    
    // MARK: - Initialisers
    
    init(size: CGSize = CGSize(width: 20, height: 20), operationSymbol: OperationSymbol, fillColour: UIColor, fontColour: UIColor) {
        self.operationSymbol = operationSymbol
        self.fillColour = fillColour
        self.fontColour = fontColour
        super.init(texture: nil, color: .clear, size: size)
        self.addChild(container, verticalAlign: .centre, horizontalAlign: .centre)
        container.addChild(label, verticalAlign: .centre, horizontalAlign: .centre)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Child Nodes
    
    /**
     Decimal point node to be rendered in the middle bottom of the node's frame
     */
    private lazy var container: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), cornerRadius: 0.1 * self.size.width)
        node.fillColor = self.fillColour
        node.lineWidth = 0
        return node
    }()
    
    private lazy var label: SKLabelNode = {
        let node = SKLabelNode(text: self.operationSymbol.asText)
        node.fontColor = self.fontColour
        node.fontSize = self.size.width * 1.2
        node.fontName = "Arial Bold"
        node.verticalAlignmentMode = .center
        node.horizontalAlignmentMode = .center
        return node
    }()
}
