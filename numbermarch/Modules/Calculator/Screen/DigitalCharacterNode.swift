//
//  DigitalCharacterNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 21/05/22.
//

import Foundation

import SpriteKit


/**
 Represents a character that can be displayed on a screen
 */
enum DigitalCharacter: Int {
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

/**
 Represents a character on the screen. Rendered to look like the old school digital characters
 
 Characters are rendered by showing/hiding the 8 bars that make up a character.
 
 ````
  _
 | |
  -
 | |
  -

 ````
 */
class DigitalCharacterNode: SKSpriteNode {
    
    // MARK: - Public Properties
    
    /**
     The digital character being presented by the node
     */
    var character: DigitalCharacter = .space {
        didSet {
            self.configureCharacter(character)
        }
    }
     
    // MARK: - Private Properties
    
    /// The thickness of the digit's bars
    private var barThickness: CGFloat {
        return 1/4 * self.size.width
    }
    
    /// The space between bars
    private var barSpacer: CGFloat {
        let spacer = 0.3 * self.barThickness
        if spacer < 2 {
            return 2
        }
        return spacer
    }
    
    /// The distance bars need to move from each other to achieve barSpacer gap.
    private var barSpacerShift: CGFloat {
        return sqrt((self.barSpacer * self.barSpacer)/2)
    }
    
    /// Colour of bar borders
    private var barStroke: UIColor = UIColor.gameBattlefieldText
    
    /// Colour of bar fill
    private var barFill: UIColor = UIColor.gameBattlefieldText
    
    /**
     Each array in the mapping represents a display character. The flags in each array determine which bars are visible starting from the top bar, working clockwise and finishing with the middle bar.
    */
    private var valueBarMap:[[Int]] = [
        [1,1,1,1,1,1,0], // 0
        [0,1,1,0,0,0,0], // 1
        [1,1,0,1,1,0,1], // 2
        [1,1,1,1,0,0,1], // 3
        [0,1,1,0,0,1,1], // 4
        [1,0,1,1,0,1,1], // 5
        [1,0,1,1,1,1,1], // 6
        [1,1,1,0,0,0,0], // 7
        [1,1,1,1,1,1,1], // 8
        [1,1,1,1,0,1,1], // 9
        [0,0,1,0,1,0,1], // n
        [1,0,0,1,0,0,1], // 3 lives
        [0,0,0,1,0,0,1], // 2 lives
        [0,0,0,0,0,0,1], // 1 life or hyphen
        [0,0,0,0,0,0,0], // space
    ]
    
    // MARK: - Initializers
    
    init(character: DigitalCharacter, size: CGSize = CGSize(width: 15, height: 40)) {
        self.character = character
        super.init(texture: nil, color: .clear, size: size)
        
        self.addChild(self.barTop)
        self.addChild(self.barTopRight)
        self.addChild(self.barBottomRight)
        self.addChild(self.barBottom)
        self.addChild(self.barBottomLeft)
        self.addChild(self.barTopLeft)
        self.addChild(self.barMiddle)
        
        self.bars.append(contentsOf: [self.barTop,
                                      self.barTopRight,
                                      self.barBottomRight,
                                      self.barBottom,
                                      self.barBottomLeft,
                                      self.barTopLeft,
                                      self.barMiddle])
        self.configureCharacter(character)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureCharacter(_ character: DigitalCharacter) {
        guard character.rawValue < self.valueBarMap.count else { return }
        
        let visibleBars = self.valueBarMap[character.rawValue]
        for (index,item) in self.bars.enumerated() {
            item.fillColor = visibleBars[index] == 1 ? UIColor.gameBattlefieldText : UIColor.gameBattlefieldTextBackground
            item.strokeColor = visibleBars[index] == 1 ? UIColor.gameBattlefieldText : UIColor.gameBattlefieldTextBackground
        }
    }
    
    
    // MARK: - Bar Nodes
    
    /// Array containing all the bars of the character
    private var bars:[SKShapeNode] = [SKShapeNode]()
    
    /**
     Top bar shape
     ````
     ______
     \____/
     ````
     */
    private lazy var barTop: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.size.width
        let h = self.barThickness
        bar.move(to: CGPoint(x: -w/2, y: h/2)) // top left
        bar.addLine(to: CGPoint(x: w/2, y: h/2)) // top right
        bar.addLine(to: CGPoint(x: (w-2*h)/2, y: -h/2)) // bottom right
        bar.addLine(to: CGPoint(x: -(w-2*h)/2, y: -h/2)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: 0, y: self.size.height/2 - self.barThickness/2 + 2*self.barSpacerShift)
        return node
    }()
    
    /**
     Top right bar shape
     ````
     /|
     ||
     ||
     \/
     ````
     */
    private lazy var barTopRight: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.barThickness
        let h = self.size.height/2
        bar.move(to: CGPoint(x: -w/2, y: h/2-w)) // top left
        bar.addLine(to: CGPoint(x: w/2, y: h/2)) // top right
        bar.addLine(to: CGPoint(x: w/2, y: -h/2+w/2)) // bottom right
        bar.addLine(to: CGPoint(x: 0, y: -h/2)) // bottom point
        bar.addLine(to: CGPoint(x: -w/2, y: -h/2+w/2)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: self.size.width/2 - self.barThickness/2 + self.barSpacerShift, y: self.size.height/4 + self.barSpacerShift)
        return node
    }()
    
    /**
     Bottom right bar shape
     ````
     /\
     ||
     ||
     \|
     ````
     */
    private lazy var barBottomRight: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.barThickness
        let h = self.size.height/2
        bar.move(to: CGPoint(x: -w/2, y: h/2-w/2)) // top left
        bar.addLine(to: CGPoint(x: 0, y: h/2)) // top point
        bar.addLine(to: CGPoint(x: w/2, y: h/2-w/2)) // top right
        bar.addLine(to: CGPoint(x: w/2, y: -h/2)) // bottom right
        bar.addLine(to: CGPoint(x: -w/2, y: -h/2+w)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: self.size.width/2 - self.barThickness/2 + self.self.barSpacerShift, y: -self.size.height/4 - self.barSpacerShift)
        return node
    }()
    
    /**
     Top bar shape
     ````
      ____
     /____\
     ````
     */
    private lazy var barBottom: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.size.width
        let h = self.barThickness
        bar.move(to: CGPoint(x: -w/2+h, y: h/2)) // top left
        bar.addLine(to: CGPoint(x: w/2-h, y: h/2)) // top right
        bar.addLine(to: CGPoint(x: w/2, y: -h/2)) // bottom right
        bar.addLine(to: CGPoint(x: -w/2, y: -h/2)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: 0, y: -self.size.height/2 + self.barThickness/2 - 2*self.barSpacerShift)
        return node
    }()
    
    /**
     Bottom left bar shape
     ````
     /\
     ||
     ||
     |/
     ````
     */
    private lazy var barBottomLeft: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.barThickness
        let h = self.size.height/2
        bar.move(to: CGPoint(x: -w/2, y: h/2-w/2)) // top left
        bar.addLine(to: CGPoint(x: 0, y: h/2)) // top point
        bar.addLine(to: CGPoint(x: w/2, y: h/2-w/2)) // top right
        bar.addLine(to: CGPoint(x: w/2, y: -h/2+w)) // bottom right
        bar.addLine(to: CGPoint(x: -w/2, y: -h/2)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: -self.size.width/2 + self.barThickness/2 - self.barSpacerShift, y: -self.size.height/4 - self.barSpacerShift)
        return node
    }()
    
    /**
     Top left bar shape
     ````
     |\
     ||
     ||
     \/
     ````
     */
    private lazy var barTopLeft: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.barThickness
        let h = self.size.height/2
        bar.move(to: CGPoint(x: -w/2, y: h/2)) // top left
        bar.addLine(to: CGPoint(x: w/2, y: h/2-w)) // top right
        bar.addLine(to: CGPoint(x: w/2, y: -h/2+w/2)) // bottom right
        bar.addLine(to: CGPoint(x: 0, y: -h/2)) // bottom point
        bar.addLine(to: CGPoint(x: -w/2, y: -h/2+w/2)) // bottom left
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: -self.size.width/2 + self.barThickness/2 - self.barSpacerShift, y: self.size.height/4 + self.barSpacerShift)
        return node
    }()
    
    /**
     Middle bar shape
     ````
      ____
     <____>
     ````
     */
    private lazy var barMiddle: SKShapeNode = {
        let bar = UIBezierPath()
        let w = self.size.width
        let h = self.barThickness
        bar.move(to: CGPoint(x: -w/2 + h, y: h/2)) // top left
        bar.addLine(to: CGPoint(x: w/2 - h, y: h/2)) // top right
        bar.addLine(to: CGPoint(x: w/2-h/2, y: 0)) // right point
        bar.addLine(to: CGPoint(x: w/2-h, y: -h/2)) // bottom right
        bar.addLine(to: CGPoint(x: -w/2+h, y: -h/2)) // bottom left
        bar.addLine(to: CGPoint(x: -w/2+h/2, y: 0)) // left point
        bar.close()
        let node = SKShapeNode(path: bar.cgPath)
        node.strokeColor = self.barStroke
        node.fillColor = self.barFill
        node.position = CGPoint(x: 0, y: 0)
        return node
    }()
    
}

