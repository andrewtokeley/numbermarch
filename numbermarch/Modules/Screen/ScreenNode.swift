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
     This value determines the amount of lean each digita character has. 1 would mean they lean over their full width. Default is 0.2.
     */
    private let skew: CGFloat = 0.2
    
    /**
     Proportional distance for the smallest margin gap
     */
    private var GAP: CGFloat {
        return 0.15 * self.frame.height
    }
    
    // MARK: - Private Properties
    
    private var _showCellBorders: Bool = false
    
    var showCellBorders: Bool {
        get {
            return _showCellBorders
        }
        set {
            _showCellBorders = newValue
            self.setCellBorders(_showCellBorders)
        }
    }
    
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
     Reference to the digital characters displayed on the screen
     */
    public var screenCharacterNodes: [DigitalCharacterNode] =  [DigitalCharacterNode]()
  
    /**
     Reference to the digital decimal points displayed between digits on the screen
     */
    public var decimalPointNodes: [DigitalDecimalPointNode] = [DigitalDecimalPointNode]()
    
    private var subTextNodes: [SKLabelNode] = [SKLabelNode]()
    
    private var cellBorderNodes: [SKShapeNode] = [SKShapeNode]()
    
    /**
     The size of a digital character, where the width allows for a ``spaceBetweenCharacters`` on the left and right of the screen and the same gap between digits. The height of a digital character is always twice the width.
     */
    private var characterSize: CGSize {
        let totalGaps = CGFloat(self.numberOfCharacters + 1) * spaceBetweenCharacters
        let width = (self.frame.width - totalGaps) / CGFloat(self.numberOfCharacters)
        return CGSize(width: width, height: 2*width)
    }
    
    /**
     Returns the size a decimal point character should be. This is sized to be half the width of the space between characters.
     */
    private var decimalPointSize: CGSize {
        return CGSize(width: self.spaceBetweenCharacters/2, height: self.characterSize.height)
    }
    
    private var spaceBetweenCharacters: CGFloat {
        // define a width between each character on the screen
        return GAP
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
        
        self.textLabel.position = CGPoint(x: -self.frame.width/2 + self.spaceBetweenCharacters + self.characterSize.width, y: self.frame.height/2 - 0.5 * GAP)
        self.addChild(self.textLabel)
        
        self.addDigitalCharacterNodes()
        self.addDecimalPointNodes()
        self.addCellBorders()
        self.addSubTextNodes()
    }
    
    /**
     Cause XCode said I had to :-)
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    /**
     Draws a border around each cell
     */
    private func setCellBorders(_ showCellBorders: Bool) {
        for position in 1...self.numberOfCharacters {
            self.cellBorderNodes[position-1].strokeColor = showCellBorders ? .gameBlue : .clear
        }
    }
    
    /**
     Returns the point at the centre of a digit for a given position, where position 1 is the first position on the screen and each digit has a ``GAP`` space.
     
     Note, when adding digits to the screen, remeber Digits have an anchor at their centre, but the screen (SKSpriteNode) they are being added to has its origin at (0,0)
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
    
    /**
     Returns the point in the screen's coordinate system (origin at (0,0)). The postion for a decimal point is 1/2 a ``GAP`` distance to the right of its neighbouring digit.
     */
    private func cgPointAtScreenPositionForDecimal(_ screenPosition: Int) -> CGPoint {
        return cgPointAtScreenPosition(screenPosition).offsetBy(dx: self.characterSize.width/2 + self.decimalPointSize.width/2 * 0.2, dy: 0)
    }
    
    // MARK: - Children
    
//    private lazy var decimalPoint: DigitalDecimalPointNode = {
//        let node = DigitalDecimalPointNode(size: self.decimalPointSize)
//        return node
//    }()
    
    private lazy var textLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontName = "Arial"
        label.fontSize = self.GAP * 1.3
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        label.fontColor = .black //UIColor.gameBattlefieldText
        return label
    }()
    
    /**
     Fills the screen with character nodes, all set to be a space
     */
    private func addDigitalCharacterNodes() {
        
        // default to empty spaces
        let screenCharacters = Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters)
        
        self.screenCharacterNodes = screenCharacters.map { DigitalCharacterNode(character: $0, size: self.characterSize) }
        
        for position in 1...self.numberOfCharacters {
            let node = self.screenCharacterNodes[position - 1]
            node.position = self.cgPointAtScreenPosition(position).offsetBy(dx: -self.skew*self.characterSize.width, dy: 0)
            self.addChild(node, skewValue: self.skew)
        }
    }
    
    /**
     Adds small subtext label nodes below each cell
     */
    private func addSubTextNodes() {
        // default to all hidden
        for position in 1...self.numberOfCharacters {
            let node = SKLabelNode(text: "")
            node.fontName = "Arial"
            node.fontSize = self.GAP * 1.4
            node.fontColor = .gameBattlefieldText
            let x = self.cgPointAtScreenPositionForDecimal(position).x
            let y = -self.size.height/2 - GAP * 1.3
            node.position = CGPoint(x: x, y: y)
            self.subTextNodes.append(node)
            self.addChild(node)
        }
    }
    
    /**
     Add the decimal place nodes in hidden state
     */
    private func addDecimalPointNodes() {
        
        // default to all hidden
        for position in 1...self.numberOfCharacters {
            let node = DigitalDecimalPointNode(size: self.decimalPointSize)
            node.position = self.cgPointAtScreenPositionForDecimal(position)
            node.isHidden = true
            self.decimalPointNodes.append(node)
            self.addChild(node, skewValue: self.skew)
        }
    }
    
    /**
     Returns the screen position of the first decimal point. If no decimal point is visible this function returns nil. When the screen is displaying numbers there will only be one decimal point, but theoretcially you could display many.
     */
    private func decimalPointPosition() -> Int? {
        if let index = self.decimalPointNodes.firstIndex(where: { !$0.isHidden }) {
            return index + 1
        } else {
            return nil
        }
    }
        
    /**
     Adds the cell border cells, initially in a clear state. Can be shown by setting the ``showCellBorders`` property
     */
    private func addCellBorders() {
        for position in 1...self.numberOfCharacters {
            let border = SKShapeNode(rectOf: self.characterSize.offSetBy(dw: GAP, dh: GAP))
            border.fillColor = .clear
            border.strokeColor = .clear
            border.position = cgPointAtScreenPosition(position)
            self.cellBorderNodes.append(border)
            self.addChild(border)
        }
    }
}

// MARK: - ScreenProtocol

/**
 All screens must be able to do these things!
 */
extension ScreenNode: ScreenProtocol {
    
    public var canAppendWithoutLoss: Bool {
        return self.characterAt(1) == .space
    }
    
    public var asNumber: NSNumber? {
        if let float = Float(self.displayAsString) {
            return NSNumber(value: float)
        }
        return nil
    }
    
    private var displayAsString: String {
        var result = ""
        for position in 1...self.numberOfCharacters {
            if let c = self.characterAt(position) {
                if let text = c.asText {
                    result += text
                }
            }
        }
        return result
    }
    
    func displayTextMessage(text: String) {
        self.textLabel.text = text.uppercased()
    }
    
    func displaySubText(text: String, position: Int) {
        guard position.isBetween(1, self.numberOfCharacters, true) else { return }
        self.subTextNodes[position - 1].text = text
    }
    
    func freezeCharacters(screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        self.freezePosition = screenPosition
    }
    
    func clearScreen(includingMessageText: Bool) {
        self.display(Array(repeating: DigitalCharacter.space, count: self.numberOfCharacters), screenPosition: self.numberOfCharacters)
        
        if includingMessageText {
            self.displayTextMessage(text: "")
        }
        
        // remove any decimal places
        let visibleDPs = self.decimalPointNodes.filter( { $0.isHidden == false } )
        visibleDPs.forEach { dp in
            dp.isHidden = true
        }
    }
    
    func append(_ character: DigitalCharacter) {
        // move all characters to the left, but protecting any characters from freezePosition back.
        for position in (freezePosition + 1)...(self.numberOfCharacters - 1) {
            if let copy = self.characterAt(position + 1) {
                self.display(copy, screenPosition: position)
            }
        }
        
        // display the new character at the far right of screen
        self.display(character, screenPosition: self.numberOfCharacters)
        
        // shift the decimal place to the right
        if let newDPPosition = self.decimalPointPosition() {
            if newDPPosition > 1 {
                self.displayDecimalPoint(newDPPosition - 1)
            }
        }
    }
    
    func append(_ character: DigitalCharacter, delay: TimeInterval, completion: (() -> Void)?) {
        self.delayTimer?.invalidate()
        
        self.append(character)
        self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func appendDecimalPoint() {
        displayDecimalPoint(self.numberOfCharacters)
    }
    
    func removeDecimalPoint(screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        for position in screenPosition...(freezePosition + 2) {
            if let copy = self.characterAt(position - 1) {
                self.display(copy, screenPosition: position)
            }
        }
        self.display(.space, screenPosition: freezePosition + 1)
    }
    
    func remove(screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        for position in screenPosition...(freezePosition + 2) {
            if let copy = self.characterAt(position - 1) {
                self.display(copy, screenPosition: position)
            }
        }
        self.display(.space, screenPosition: freezePosition + 1)
    }
    
    func displayDecimalPoint(_ screenPosition: Int, makeUnique: Bool) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        if makeUnique {
            self.decimalPointNodes.forEach { $0.isHidden = true }
        }
        self.decimalPointNodes[screenPosition - 1].isHidden = false
    }
    
    func removeDecimalPoint(_ screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        self.decimalPointNodes[screenPosition - 1].isHidden = true
    }
    
    func display(_ character: DigitalCharacter, screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }

        self.screenCharacterNodes[screenPosition - 1].character = character
    }
    
    func display(_ characters: [DigitalCharacter], screenPosition: Int) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        // reference to the position to start displaying the digit
        var position = screenPosition
        
        // iterate through the characters from the last one to the first
        var charIndex = characters.count - 1
        while charIndex >= 0 && position >= 1 {
            if charIndex < characters.count {
                if characters[charIndex] == .point {
                    self.displayDecimalPoint(position)
                } else {
                    self.display(characters[charIndex], screenPosition: position)
                    position -= 1
                }
            }
            charIndex -= 1
        }
    }
    
    func display(_ characters: [DigitalCharacter], screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        self.delayTimer?.invalidate()
        self.display(characters, screenPosition: screenPosition)
        self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            completion?()
        }
    }
    
    func display(_ string: String, screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?) {
        guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        // create [DisplayCharater] from string
        var result = [DigitalCharacter]()
        for c in string {
            if let number = Int(String(c)) {
                result.append(DigitalCharacter(rawValue: number) ?? .space)
            } else {
                if c == "-" {
                    result.append(.onebar)
                } else if c == "." {
                    result.append(.point)
                } else if c == " " {
                    result.append(.space)
                }
            }
        }
        self.display(result, screenPosition: screenPosition)
        //guard screenPosition.isBetween(1, self.numberOfCharacters, true) else { return }
        
        if let completion = completion {
            self.delayTimer?.invalidate()
            self.delayTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
                completion()
            }
        }
    }
    
    func display(_ number: Double) {
        
        // reference to the position to start displaying digits
        var position = self.numberOfCharacters
        
        let characters = String(number)
        
        // iterate through the characters from the last one to the first
        var charIndex = characters.count - 1
        while charIndex >= 0 && position >= 1 {
            if charIndex < characters.count {
                if characters[charIndex] == "." {
                    self.displayDecimalPoint(position, makeUnique: true)
                } else {
                    self.display(String(characters[charIndex]), screenPosition: position)
                    position -= 1
                }
            }
            charIndex -= 1
        }
    }
    
    func characterAt(_ position: Int) -> DigitalCharacter? {
        guard position.isBetween(1, self.numberOfCharacters, true) else { return nil }
        return self.screenCharacterNodes[position - 1].character
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
