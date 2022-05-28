//
//  ScreenScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation
import SpriteKit

class ScreenScene: SKScene {
    
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
     Default initialiser
     */
    init(numberOfCharacters: Int, size: CGSize = CGSize(width: 300, height: 100)) {
        self.numberOfCharacters = numberOfCharacters
        let screenCharacters = Array(repeating: DisplayCharacter.space, count: self.numberOfCharacters)
        self.screenCharacterNodes = screenCharacters.map { DigitalCharacterNode(value: $0.rawValue ) }
        super.init(size: size)
        
        self.backgroundColor = UIColor.gameBackground
        self.addSpaceCharacterNodes()
    }
    
    /**
        Returns the screen position for a given position, where position 1 is the first position on the screen
     */
    private func cgPointAtScreenPosition(_ screenPosition: Int) -> CGPoint {
        return CGPoint(x: self.spaceForCharacter * CGFloat(screenPosition) - 0.5 * self.spaceForCharacter, y: self.size.height/2)
    }
    
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScreenScene: ScreenProtocol {
    
    func freezeCharacters(screenPosition: Int) {
        self.freezePosition = screenPosition
    }
    
    func append(_ character: DisplayCharacter) {
        // move all characters to the left, but protecting any characters from freezePosition back.
        for position in (freezePosition + 1)...(self.numberOfCharacters - 1) {
            let copy = self.characterAt(position + 1)
            self.display(copy, screenPosition: position)
        }
        
        // add to the end of the screen
        self.display(character, screenPosition: self.numberOfCharacters)
    }
    
    func display(_ character: DisplayCharacter, screenPosition: Int) {
        self.screenCharacterNodes[screenPosition - 1].value = character.rawValue
    }
    
    func display(_ characters: [DisplayCharacter], screenPosition: Int) {
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
    
    func characterAt(_ screenPosition: Int) -> DisplayCharacter {
        return DisplayCharacter(rawValue: self.screenCharacterNodes[screenPosition - 1].value) ?? DisplayCharacter.space
    }
    
    
}
