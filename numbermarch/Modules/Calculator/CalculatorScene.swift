//
//  CalculatorScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 30/05/22.
//

import Foundation
import SpriteKit

class CalculatorScene: SKScene {
    
    private var sizeButton: CGSize {
        return CGSize(width: self.frame.width/7, height: self.frame.height/20)
    }
    
    private var GAP: CGFloat {
        return  10 //0.07 * self.frame.height
    }
    
    private var CALC_WIDTH: CGFloat {
        return self.frame.width*0.9
    }
    
    private var dimensions: CalculatorDimensions!
    
    public var keyboardDelegate: KeyboardDelegate?
    
    /**
     Ratio between height an width is 10:6
     */
    private var CALC_HEIGHT: CGFloat {
        return CALC_WIDTH * 10/6
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.backgroundColor = .black
        
        self.dimensions = CalculatorDimensions(width: self.size.width)
        self.addChildNodes()
    }
    
    private func addChildNodes() {
        self.addChild(self.calculatorBackground, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -100))
        self.addChild(self.screen, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -100-dimensions.distanceFromTopToScreenTop))
    }
    
    public lazy var calculatorBackground: SKSpriteNode   = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "Background"), size: CGSize(width: dimensions.size.width, height: dimensions.size.height))
        node.name = "calculator"
        return node
    }()
    
    public lazy var screen: ScreenNode = {
        let node = ScreenNode(numberOfCharacters: 9, size: CGSize(width: self.dimensions.screenSize.width, height: self.dimensions.screenSize.height))
        node.display("08-016430", screenPosition: 1)
        node.displayTextMessage(text: "GAME OVER")
        return node
    }()

    // MARK: - Game
    
    /**
    Creates a new instance of SpaceInvaders game and calls it's start method.
     */
    private func startGame() {
        let game = SpaceInvaders(screen: screen, warRules: SpaceInvadersWarRules(), battleRules: SpaceInvaderBattleRules())
        self.keyboardDelegate = game
        game.start()
    }
    
    public func keyPressed(key: CalculatorKey) {
        if key == .game {
            startGame()
        } else {
            // pass all other key presses... (or maybe pass everything?)
            keyboardDelegate?.keyPressed(key: key)
        }
    }
//
//    override var keyCommands: [UIKeyCommand]? {
//
//        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
//
//        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
//
//        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
//
//        return [left, right, up]
//    }
//
    override var canBecomeFirstResponder: Bool {
        return true
    }
//
//    @objc private func keyPress(sender: UIKeyCommand) {
//        if let input = sender.input {
//            switch input {
//            case UIKeyCommand.inputLeftArrow:
//                self.keyboardDelegate?.keyPressed(key: .point)
//                return
//            case UIKeyCommand.inputRightArrow:
//                self.keyboardDelegate?.keyPressed(key: .plus)
//                return
//            case UIKeyCommand.inputUpArrow:
//                self.startGame()
//                return
//            default: return
//            }
//        }
//    }
//
//    @objc private func keyboardButtonClick(sender: UIButton) {
//        if let key = CalculatorKey(rawValue: sender.tag) {
//            switch key {
//            case .game:
//                self.startGame()
//            default:
//                self.keyboardDelegate?.keyPressed(key: key)
//            }
//        }
//    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "calculator" {
                    // button click
                    if let key = self.dimensions.keyAt(location) {
                        self.keyboardDelegate?.keyPressed(key: key)
                    }
                }
            }
        }
    }
}
