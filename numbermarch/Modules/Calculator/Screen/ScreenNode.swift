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
    
    /**
     The number of characters that can fit on the screen.
     
     Can only be set from within this file, but anyone can read its value
     */
    fileprivate(set) var numberOfCharacters: Int
    
    /**
     Reference to the digital characters displayed across all screen positions (including spaces)
     */
    private var screenCharacterNodes: [DigitalCharacterNode]
    
    /**
     The space allocated for each character on the screen
     */
    private var spaceForCharacter: CGFloat {
        return self.size.width / CGFloat(self.numberOfCharacters)
    }
    
    /**
     The screen position from which to not move characters when new characters are appended.
     */
    private var freezePosition: Int = 0
    
    /**
        Returns the screen position for a given position, where position 1 is the first position on the screen
     */
    private func cgPointAtScreenPosition(_ screenPosition: Int) -> CGPoint {
        return CGPoint(x: self.spaceForCharacter * CGFloat(screenPosition) - 0.5 * self.spaceForCharacter, y: self.size.height/2)
    }
    
    private lazy var textLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Arial"
        label.fontSize = 18
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.fontColor = UIColor.gameBattlefieldText
        if let characterHeight = self.screenCharacterNodes.first?.size.height {
            label.position = self.cgPointAtScreenPosition(1).offsetBy(dx: label.frame.size.width/2 * 1.1, dy: characterHeight/2 * 1.5)
        }
        return label
    }()
    
    /**
     Fills the screen with character nodes, all set to be a space
     */
    private func addSpaceCharacterNodes() {
        for position in 1...self.numberOfCharacters {
            let node = self.screenCharacterNodes[position - 1]
            node.position = self.cgPointAtScreenPosition(position)
            self.addChild(node)
        }
    }
    
    // MARK: - Initialisers
    
    /**
     Default initialiser
     */
    init(numberOfCharacters: Int, size: CGSize = CGSize(width: 300, height: 100)) {
        self.numberOfCharacters = numberOfCharacters
        let screenCharacters = Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters)
        self.screenCharacterNodes = screenCharacters.map { DigitalCharacterNode(character: $0) }
        super.init(texture: nil, color: .clear, size: size)
        
        self.color = UIColor.gameBackground
        self.addSpaceCharacterNodes()
        self.addChild(textLabel)
    }
    
    /**
     Cause XCode said I had to :-)
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
