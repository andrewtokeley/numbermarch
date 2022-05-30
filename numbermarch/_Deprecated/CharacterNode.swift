//
//  CharacterNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/05/22.
//

import Foundation
import SpriteKit

class CharacterNode: NumberNode {
    
    /**
     Overrides the setter for value property, in order to translate it into it's textual representation
     */
    override var value:Int {
        didSet {
            self.valueLabel.text = self.getTextForValue(value: value)
        }
    }
    
    // MARK: - Private Properties
    
    /// Font size of the character
    private var fontSize: CGFloat = 40
    
    /// Height, in points, of the character based on its fontSize
    private var fontHeight: CGFloat? {
        if let name = self.valueLabel.fontName {
            return UIFont(name: name, size: self.valueLabel.fontSize)?.capHeight
        }
        return nil
    }
    
    /// Colour of the character
    private var textColour: UIColor = .gameBattlefieldText {
        didSet {
            self.valueLabel.fontColor = textColour
        }
    }
    
    // MARK: - Child Nodes
    
    /// The SKLabel node of the character
    lazy var valueLabel: SKLabelNode = {
        //let node = SKLabelNode(fontNamed: "AvenirNext-Bold")
        //let node = SKLabelNode(fontNamed: "Courier")
        let node = SKLabelNode(fontNamed: "Menlo-Bold")
        node.text = String(value)
        node.fontSize = self.fontSize
        node.fontColor = .gameBattlefieldText
        node.zPosition = 100
        node.horizontalAlignmentMode = .center
        node.verticalAlignmentMode = .center
        node.position = CGPoint(x: 0, y:0)
        
        return node
    }()
    
    // MARK: - Private Methods
    
    /**
     Returns the text representation of the value. 0 to 9 is as expected and 10 is the mothership
    
     - Parameters:
        - value: value to converted
     
     - Returns:
     String representation of the value
     */
    private func getTextForValue(value: Int) -> String {
        if (value) == 10 {
            return "Ω";
        }
        return String(value)
    }
    
    // MARK: - Initializers
    
    /**
    Default constructor
     
     - Parameters:
        - value: this is the value
        - fontSize: the size of the font
    
     */
    init(value: Int, fontSize:CGFloat = 40, size: CGSize = CGSize(width: 35, height: 40)) {
        super.init(size: size, value: value)
        self.fontSize = fontSize
        valueLabel.text = self.getTextForValue(value: value)
        self.addChild(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

