//
//  ScreenScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation
import SpriteKit

//class ScreenScene: SKScene {
class ScreenNode: SKSpriteNode {
    
    // MARK: - Private Constants
    
    /**
     Proportional distance for the smallest margin gap
     */
    private var GAP: CGFloat {
        return 0.1 * self.frame.height
    }
    
    // MARK: - Private Properties
    
    /**
     The number of characters that can fit on the screen.
     
     Can only be set from within this file, but anyone can read its value
     */
    fileprivate(set) var numberOfCharacters: Int
    
    /**
     Reference to the digital characters displayed across all screen positions (including spaces)
     */
    private var screenCharacterNodes: [DigitalCharacterNode] =  [DigitalCharacterNode]()
  
    /**
     The size of a digital character, always in the ratio 1:2 (w:h)
     */
    private var characterSize: CGSize {
        // define a width that allows for a GAP space on the left and right of the display and a GAP between digits
        let totalGap = 2*GAP + CGFloat(self.numberOfCharacters - 1)*GAP
        let width = (self.display.frame.width - totalGap) / CGFloat(self.numberOfCharacters)
        return CGSize(width: width, height: 2*width)
    }
    
    /**
     The screen position from which to not move characters when new characters are appended.
     */
    private var freezePosition: Int = 0
    
    // MARK: - Initialisers
    
    /**
     Default initialiser
     */
    init(numberOfCharacters: Int, size: CGSize = CGSize(width: 300, height: 100)) {
        self.numberOfCharacters = numberOfCharacters
        super.init(texture: nil, color: .clear, size: size)
        self.color = .clear
        
        
        // Add the highest level node, it contains all the children for the screen
        self.border.position = CGPoint(x: -self.frame.width/2, y: -self.frame.height/2)
        self.addChild(self.border)
        self.border.addChild(innerBorder, verticalAlign: .centre, horizontalAlign: .centre)
        self.innerBorder.addChild(display, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -0.2 * self.display.frame.height))
        self.display.addChild(self.textLabel, verticalAlign: .top, horizontalAlign: .left, offSet: CGVector(dx: 2 * GAP, dy: -0.5 * GAP))
        self.textLabel.text = "GAME OVER"
        
        self.addSpaceCharacterNodes(display: self.display)
//
    }
    
    /**
     Cause XCode said I had to :-)
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
     
    /**
        Returns the screen position for a given position, where position 1 is the first position on the screen. The positions assume the digits are placed relative to an anchor in their centre (0.5, 0.5).
     */
    private func cgPointAtScreenPosition(_ screenPosition: Int) -> CGPoint {
        
        var x = self.characterSize.width * CGFloat(screenPosition) - 0.5 * self.characterSize.width
        
        // add a gap between digits
        x += GAP * CGFloat(screenPosition - 1)
        
        // centre vertically on display - DigitalCharacterNodes are SKSpriteNodes so (0.5, 0.5 anchored)
        let height = self.characterSize.height/2 + GAP
        
        return CGPoint(x: x + GAP , y: height)
    }
    
    // MARK: - Children
    
    private lazy var border: SKShapeNode = {
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: 0.05 * self.frame.height)
        node.strokeColor = .clear
        node.fillColor = UIColor.black
        return node
    }()
    
    private lazy var innerBorder: SKShapeNode = {
        let rect = CGRect(x: 0, y: 0, width: self.frame.width-2*GAP, height: self.frame.height-2*GAP)
        let node = SKShapeNode(rect: rect, cornerRadius: 0.05 * self.frame.height)
        node.strokeColor = .clear
        node.fillColor = UIColor.calculatorScreenBorder
        return node
    }()
    
    private lazy var display: SKShapeNode = {
        let rect = CGRect(x: 0, y: 0, width: self.frame.width-4*GAP, height: self.frame.height - 5 * GAP)
        let node = SKShapeNode(rect: rect, cornerRadius: 0.05 * self.frame.height)
        node.strokeColor = .clear
        node.fillColor = .calculatorScreen
        return node
    }()
    
    private lazy var textLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Arial"
        label.fontSize = GAP
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        label.fontColor = .black //UIColor.gameBattlefieldText
//        if let characterHeight = self.screenCharacterNodes.first?.size.height {
//            label.position = self.cgPointAtScreenPosition(1).offsetBy(dx: label.frame.size.width/2 * 1.1, dy: characterHeight/2 * 1.5)
//        }
        return label
    }()
    
    /**
     Fills the screen with character nodes, all set to be a space
     */
    private func addSpaceCharacterNodes(display: SKShapeNode) {
        
        // default to empty spaces
        let screenCharacters = Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters)
        
        self.screenCharacterNodes = screenCharacters.map { DigitalCharacterNode(character: $0, size: self.characterSize) }
        
        for position in 1...self.numberOfCharacters {
            let node = self.screenCharacterNodes[position - 1]
            node.position = self.cgPointAtScreenPosition(position)
            display.addChild(node)
            
        }
    }
    
    
}

// MARK: - ScreenProtocol

/**
 All screens must be able to do these things!
 */
extension ScreenNode: ScreenProtocol {
    
    func displayTextMessage(text: String) {
        self.textLabel.text = text.uppercased()
    }
    
    func freezeCharacters(screenPosition: Int) {
        self.freezePosition = screenPosition
    }
    
    func clearScreen() {
        self.display(Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters), screenPosition: self.numberOfCharacters)
        self.displayTextMessage(text: "")
    }
    
    func append(_ character: DigitalCharacter) {
        // move all characters to the left, but protecting any characters from freezePosition back.
        for position in (freezePosition + 1)...(self.numberOfCharacters - 1) {
            let copy = self.characterAt(position + 1)
            self.display(copy, screenPosition: position)
        }
        
        // add to the end of the screen
        self.display(character, screenPosition: self.numberOfCharacters)
    }
    
    func append(_ character: DigitalCharacter, delay: TimeInterval, completion: (() -> Void)?) {
        self.append(character)
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func remove(screenPosition: Int) {
        for position in screenPosition...(freezePosition + 2) {
            let copy = self.characterAt(position - 1)
            self.display(copy, screenPosition: position)
        }
        self.display(.space, screenPosition: freezePosition + 1)
    }
    
    func display(_ character: DigitalCharacter, screenPosition: Int) {
        self.screenCharacterNodes[screenPosition - 1].character = character
    }
    
    func display(_ characters: [DigitalCharacter], screenPosition: Int) {
        var position = self.numberOfCharacters
        var charIndex = characters.count - 1 // start from the end of the array of characters
        while charIndex >= 0 && position >= 1 {
            if charIndex < characters.count {
                self.display(characters[charIndex], screenPosition: position)
            }
            position -= 1
            charIndex -= 1
        }
    }
    
    func display(_ characters: [DigitalCharacter], screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?) {
        self.display(characters, screenPosition: screenPosition)
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func display(_ string: String, screenPosition: Int) {
        // create [DisplayCharater] from string
        var result = [DigitalCharacter]()
        for c in string {
            if let number = Int(String(c)) {
                result.append(DigitalCharacter(rawValue: number) ?? .space)
            } else {
                if c == "-" {
                    result.append(.onebar)
                } else if c == " " {
                    result.append(.space)
                }
            }
        }
        self.display(result, screenPosition: screenPosition)
    }
    
    func display(_ string: String, screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?) {
        self.display(string, screenPosition: screenPosition)
        let _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func characterAt(_ screenPosition: Int) -> DigitalCharacter {
        return self.screenCharacterNodes[screenPosition - 1].character
    }
    
    func findPosition(_ character: DigitalCharacter, fromPosition: Int = 1) -> Int? {
        for (index, node) in self.screenCharacterNodes.enumerated() {
            if index >= (fromPosition - 1) {
                if node.character == character {
                    return index + 1
                }
            }
        }
        return nil
    }
    
}
