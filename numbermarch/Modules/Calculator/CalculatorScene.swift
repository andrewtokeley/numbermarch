//
//  CalculatorScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 30/05/22.
//

import Foundation
import SpriteKit
import SwiftUI

enum CalculatorSwitchPosition: Int {
    case off = 0
    case on1 = 1
    case on2 = 2
    func next() -> CalculatorSwitchPosition {
        let nextRawValue = self.rawValue == 2 ? 0 : self.rawValue + 1
        return CalculatorSwitchPosition(rawValue: nextRawValue) ?? self
    }
}

class CalculatorScene: SKScene {
    
    /**
     If defined then a game is in progress
     */
    private var game: GamesProtocol?
    
    /**
     If defined, this engine will be used to respond to key presses on the calcluator
     */
    private var numberEngine: NumberEngine?
    
//    private var calculatorEngine: CalculatorEngine?
//    private var musicEngine: MusicEngine?
    private var haptic = UIImpactFeedbackGenerator(style: .light)
    
    private var skin: CalculatorSkin
    
    // MARK: - Initialisers
    
    init(size: CGSize, skin: CalculatorSkin) {
        self.skin = skin
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Properties
    
    private var onOffSwitch = CalculatorSwitchPosition.off {
        didSet(value) {
            self.calculatorSwitch.texture = self.skin.switchTexture(value)
        }
    }
    
    /**
     The delegate will be advised of any key presses within the calculator
     */
    public var keyboardDelegate: KeyboardDelegate?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.backgroundColor = .white
        haptic.prepare()
        self.switchToPosition(.off)
        
        // Note child nodes are added in the didChangeSize override because otherwise things dont work!
    }
    
    // MARK: - Child Nodes
    
    private func addChildNodes() {
        let topGap:CGFloat = 0
        
        // Remove so we can call this method mutliple times (hack because of Swift's resizing lifecycle)
        self.calculatorBackground.removeFromParent()
        self.screen.removeFromParent()
        self.calculatorSwitch.removeFromParent()
        
        self.addChild(self.calculatorBackground, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -topGap))
        self.calculatorBackground.addChild(self.screen, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -topGap-skin.dimensions.distanceFromTopToScreenTop))
        self.calculatorSwitch.position = skin.dimensions.switchCentre
        self.calculatorBackground.addChild(self.calculatorSwitch)
        
        for i in 1...self.screen.numberOfCharacters {
            if let text = self.skin.subText(i) {
                self.screen.displaySubText(text: text, position: i)
            }
        }
    }
    
    /**
     The image of the calculator
     */
    public lazy var calculatorBackground: SKSpriteNode   = {
        let node = SKSpriteNode(texture: self.skin.calculatorTexture, size: CGSize(width: self.skin.dimensions.size.width, height: self.skin.dimensions.size.height))
        node.name = "calculator"
        return node
    }()
    
    /**
     Off/Music/Calc Switch
     */
    public lazy var calculatorSwitch: SKSpriteNode   = {
        let node = SKSpriteNode(texture: self.skin.switchTexture(.off), size: CGSize(width: self.skin.dimensions.switchSize.width, height: self.skin.dimensions.switchSize.height))
        node.name = "switch"
        return node
    }()
    
    public lazy var screen: ScreenNode = {
        let node = ScreenNode(numberOfCharacters: self.skin.screenSize, size: CGSize(width: self.skin.dimensions.screenSize.width, height: self.skin.dimensions.screenSize.height))
        node.display ("0", screenPosition: 1)
        node.showCellBorders = true
        return node
    }()

    // MARK: - Game
    
    /**
    Creates a new instance of game and calls it's start method.
     */
    private func startGame() {
        self.screen.showCellBorders = true
        self.onOffSwitch = .on2
        
        // make sure the calculator doesn't respond to standard number engine
        self.numberEngine = nil
        
        self.game?.stop()
        self.game = self.skin.game(self.screen)
        self.keyboardDelegate = game as? KeyboardDelegate
        game?.start()
    }
    
    private func switchToPosition(_ switchPosition: CalculatorSwitchPosition) {
        self.onOffSwitch = switchPosition
        
        self.numberEngine = self.skin.engineForSwitchPosition(switchPosition, screen: self.screen)
        self.keyboardDelegate = self.numberEngine
        
        if switchPosition == .off {
            self.screen.clearScreen(includingMessageText: true)
        } else {
            self.screen.display("0")
        }
        
        // if you've moved the switch any game is over
        self.game?.stop()
        self.game = nil
    }
    
//    private func switchToOff() {
//        self.onOffSwitch = .off
//        self.screen.clearScreen()
//        self.screen.showCellBorders = false
//        self.game?.stop()
//        self.keyboardDelegate = nil
//        self.game = nil
//        self.numberEngine = nil
//    }
    
//    private func switchToPosition1() {
//        self.onOffSwitch = .on1
//        self.screen.clearScreen()
//
//        // always stop the game
//        game?.stop()
//        self.game = nil
//        self.keyboardDelegate = nil
//
//        if let numberEngine = self.skin.switch1Engine(self.screen) {
//            self.numberEngine = numberEngine
//            self.keyboardDelegate = self.numberEngine
//            self.screen.display("0")
//        }
//    }
    
    
    //private func switchToCalculator() {
//        self.onOffSwitch = .on2
//        self.screen.showCellBorders = false
//        self.game?.stop()
//        self.game = nil
//
//        self.screen.clearScreen()
//        self.screen.display("0")
//
//        self.calculatorEngine = self.skin.switch1Engine(self.screen)
//        self.keyboardDelegate = self.calculatorEngine
    //}
    
//    private func switchToPosition2() {
//        self.onOffSwitch = .on2
//        self.screen.clearScreen()
//    }
    
//    private func switchToMusic() {
//        self.screen.showCellBorders = false
//        self.onOffSwitch = .on1
//        self.game?.stop()
//        self.game = nil
//
//        self.screen.clearScreen()
//        self.screen.display("0")
//
//        self.musicEngine = self.skin.switch2Function(self.screen)
//        self.keyboardDelegate = self.musicEngine
//    }
    /**
     Lets the scene know about any keys that have been pressed on the calculator. Touch events are captured by the CalculatorView and passes through this method to the scene.
     
     - Parameters:
        - key: the key that was pressed
     */
    public func keyPressed(key: CalculatorKey) {
        
        if key == .onoffSwitch {
            if onOffSwitch == .off {
                self.switchToPosition(.off)
            } else if onOffSwitch == .on1 {
                self.switchToPosition(.on1)
            } else if onOffSwitch == .on2 {
                self.switchToPosition(.on2)
            }
            return
        }
        
        if self.onOffSwitch == .off {
            // ignore any key presses if calculator is off
            return
        }
        
        if key == .game {
            if let game = game {
                if game.isGameStarted {
                    if game.isPaused {
                        game.resume()
                    } else {
                        game.pause()
                    }
                } else {
                    self.startGame()
                }
            } else {
                self.startGame()
            }
        } else {
            // pass all other key presses on to whoever has implemented the delegate (game or calc)
            // (or maybe pass everything, or just aim and fire?)
            keyboardDelegate?.keyPressed(key: key)
        }
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "calculator" {
                    let localLocation = touch.location(in: node)
                    // button click
                    if let key = self.skin.keyAt(localLocation) {
                        
                        if key == .onoffSwitch {
                            self.haptic.impactOccurred()
                            self.onOffSwitch = self.onOffSwitch.next()
                        } else {
                            if self.onOffSwitch != .off {
                                self.haptic.impactOccurred()
                            }
                        }
                        keyPressed(key: key)
                    }
                }
            }
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        print(self.size)
        print(oldSize)
        self.addChildNodes()
    }
}
