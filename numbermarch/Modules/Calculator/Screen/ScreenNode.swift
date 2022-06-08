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
     When characters are displayed on the screen, delays can be scheduled to trigger callbacks. To avoid conflicts all display methods use the same Timer instance which is cancelled and redefined whenever a new display method is called.
     */
    private var delayTimer: Timer?
    
    /**
     Reference to the digital characters displayed across all screen positions (including spaces)
     */
    private var screenCharacterNodes: [DigitalCharacterNode] =  [DigitalCharacterNode]()
  
    /**
     The size of a digital character, always in the ratio 1:2 (w:h)
     */
    private var characterSize: CGSize {
        // define a width that allows for a GAP space on the left and right of the display and a GAP between digits
        let totalGaps = CGFloat(self.numberOfCharacters + 1) * spaceBetweenCharacters
        let width = (self.frame.width - totalGaps) / CGFloat(self.numberOfCharacters)
        return CGSize(width: width, height: 2*width)
    }
    
    private var spaceBetweenCharacters: CGFloat {
        // define a width that allows for a GAP space on the left and right of the display and a GAP between digits
        return 2 * GAP
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
        
        self.textLabel.position = CGPoint(x: -self.frame.width/2 + self.spaceBetweenCharacters + self.characterSize.width, y: self.frame.height/2 - GAP)
        self.addChild(self.textLabel)
        
        self.addSpaceCharacterNodes()

    }
    
    /**
     Cause XCode said I had to :-)
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
     
    /**
     Returns the screen position for a given position, where position 1 is the first position on the screen.
     
     Digits are positioned at their centre. Digits are added to a SpriteNode which has an origin (0.0) at its centre.
     */
    private func cgPointAtScreenPosition(_ screenPosition: Int) -> CGPoint {
        guard screenPosition >= 1 && screenPosition <= self.numberOfCharacters else { return CGPoint.zero }
        
        // 1 [GAP + 0.5 characterSize]
        // 2 [GAP + 0.5 characterSize] + [0.5 characterSize + GAP + 0.5 characterSize]
        // 3 [GAP + 0.5 characterSize] + [0.5 characterSize + GAP + 0.5 characterSize] + [0.5 characterSize + GAP + 0.5 characterSize]
        // ...
        let x = (self.spaceBetweenCharacters + 0.5 * self.characterSize.width) + (self.characterSize.width + self.spaceBetweenCharacters) * (CGFloat(screenPosition) - 1)
        
        return CGPoint(x: x - self.size.width/2, y: -GAP)
    }
    
    // MARK: - Children
    
    private lazy var textLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Arial"
        label.fontSize = self.characterSize.height / 2
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        label.fontColor = .black //UIColor.gameBattlefieldText
        return label
    }()
    
    /**
     Fills the screen with character nodes, all set to be a space
     */
    private func addSpaceCharacterNodes() {
        
        // default to empty spaces
        let screenCharacters = Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters)
        
        self.screenCharacterNodes = screenCharacters.map { DigitalCharacterNode(character: $0, size: self.characterSize) }
        
        for position in 1...self.numberOfCharacters {
            let node = self.screenCharacterNodes[position - 1]
            node.position = self.cgPointAtScreenPosition(position)
            self.addChild(node)
            
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
        self.clearScreen(includingMessageText: true)
    }
    
    func clearScreen(includingMessageText: Bool) {
        self.display(Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters), screenPosition: self.numberOfCharacters)
        if includingMessageText {
            self.displayTextMessage(text: "")
        }
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
        self.delayTimer?.invalidate()
        
        self.append(character)
        self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
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
        self.delayTimer?.invalidate()
        self.display(characters, screenPosition: screenPosition)
        self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func display(_ string: String, screenPosition: Int? = nil, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        let position = screenPosition == nil ? self.numberOfCharacters : screenPosition!

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
        self.display(result, screenPosition: position)
        if completion != nil {
            self.delayTimer?.invalidate()
            self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
                completion?()
            }
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
