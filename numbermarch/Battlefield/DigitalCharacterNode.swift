//
//  DigitalCharacterNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 21/05/22.
//

import Foundation

import SpriteKit

class DigitalCharacterNode: NumberNode {
    
    // MARK: - Public Properties
    var fontSize: CGFloat = 40
    
    override var value: Int {
        didSet {
            self.updateBarVisibility(value: value)
        }
    }
    
    // MARK: - Private Properties
    
    private var derivedHeight: CGFloat? {
        return UIFont(name: "Menlo-Bold", size: self.fontSize)?.capHeight
    }
    
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
    
    private var barStroke: UIColor = UIColor.gameBattlefieldText
    private var barFill: UIColor = UIColor.gameBattlefieldText
    
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
    
    // MARK: - Initializers
    
    init(value: Int, size: CGSize = CGSize(width: 15, height: 40)) {
        super.init(size: size, value: value)
        
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
        updateBarVisibility(value: value)
    }
    
    // MARK: - Private Methods
    
    private func updateBarVisibility(value: Int) {
        guard value < self.valueBarMap.count else { return }
        
        let visibleBars = self.valueBarMap[value]
        for (index,item) in self.bars.enumerated() {
            item.fillColor = visibleBars[index] == 1 ? UIColor.gameBattlefieldText : UIColor.gameBattlefieldTextBackground
            item.strokeColor = visibleBars[index] == 1 ? UIColor.gameBattlefieldText : UIColor.gameBattlefieldTextBackground
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

