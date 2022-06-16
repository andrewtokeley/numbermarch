//
//  CalculatorScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 30/05/22.
//

import Foundation
import SpriteKit
import SwiftUI

enum CalculatorSwitch: Int {
    case off = 0
    case music = 1
    case calcGame = 2
    func next() -> CalculatorSwitch {
        let nextRawValue = self.rawValue == 2 ? 0 : self.rawValue + 1
        return CalculatorSwitch(rawValue: nextRawValue) ?? self
    }
}

class CalculatorScene: SKScene {
    
    private var game: GamesProtocol?
    private var calculatorEngine: CalculatorEngine?
    private var musicEngine: MusicEngine?
    private var haptic = UIImpactFeedbackGenerator(style: .light)
    
    private var onOffSwitch = CalculatorSwitch.off {
        didSet(value) {
            if value == .off {
                self.calculatorSwitch.texture = SKTexture(imageNamed: "Switch-Off")
            } else if value == .music {
                self.calculatorSwitch.texture = SKTexture(imageNamed: "Switch-Music")
            } else if value == .calcGame {
                self.calculatorSwitch.texture = SKTexture(imageNamed: "Switch-Cal")
            }
        }
    }
    
    private var dimensions: CalculatorDimensions!
    
    private var sizeButton: CGSize {
        return CGSize(width: self.frame.width/7, height: self.frame.height/20)
    }
    
    /**
     The delegate will be advised of any key presses within the calculator
     */
    public var keyboardDelegate: KeyboardDelegate?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.backgroundColor = .white
        haptic.prepare()
        self.dimensions = CalculatorDimensions(width: self.size.width * 0.9)
        self.addChildNodes()
        
        self.switchToOff()
    }
    
    // MARK: - Child Nodes
    
    private func addChildNodes() {
        self.addChild(self.calculatorBackground, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -100))
        self.addChild(self.screen, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -100-dimensions.distanceFromTopToScreenTop))
        
        self.calculatorSwitch.position = dimensions.switchCentre
        self.calculatorBackground.addChild(self.calculatorSwitch)
        //self.addChild(self.calculatorSwitch, verticalAlign: .centre, horizontalAlign: .left)
    }
    
    /**
     The image of the calculator
     */
    public lazy var calculatorBackground: SKSpriteNode   = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "Background"), size: CGSize(width: dimensions.size.width, height: dimensions.size.height))
        node.name = "calculator"
        return node
    }()
    
    /**
     Off/Music/Calc Switch
     */
    public lazy var calculatorSwitch: SKSpriteNode   = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "Switch-Off"), size: CGSize(width: dimensions.switchSize.width, height: dimensions.switchSize.height))
        node.name = "switch"
        return node
    }()
    
    public lazy var screen: ScreenNode = {
        let node = ScreenNode(numberOfCharacters: 9, size: CGSize(width: self.dimensions.screenSize.width, height: self.dimensions.screenSize.height))
        node.display ("0", screenPosition: 1)
        return node
    }()

    // MARK: - Game
    
    /**
    Creates a new instance of game and calls it's start method.
     */
    private func startGame() {
        self.onOffSwitch = .calcGame
        self.calculatorEngine = nil
        self.musicEngine = nil
        
        self.game?.stop()
        
        //self.game = SpaceInvaders(screen: screen, rules: DigitalInvadersClassicRules())
        self.game = EightAttack(screen: screen)
        self.keyboardDelegate = game as? KeyboardDelegate
        
        // game starts automatically
        game?.start()
    }
    
    private func switchToOff() {
        self.onOffSwitch = .off
        self.screen.clearScreen()
        self.game?.stop()
        self.keyboardDelegate = nil
        self.game = nil
        self.calculatorEngine = nil
    }
    
    private func switchToCalculator() {
        self.onOffSwitch = .calcGame
        self.game?.stop()
        self.game = nil
        
        self.screen.clearScreen()
        self.screen.display("0")
        
        self.calculatorEngine = CalculatorEngine(screen: self.screen)
        self.keyboardDelegate = self.calculatorEngine
    }
    
    private func switchToMusic() {
        self.onOffSwitch = .music
        self.game?.stop()
        self.game = nil
        
        self.screen.clearScreen()
        self.screen.display("0")
        
        self.musicEngine = MusicEngine(screen: self.screen)
        self.keyboardDelegate = self.musicEngine
    }
    /**
     Lets the scene know about any keys that have been pressed on the calculator. Touch events are captured by the CalculatorView and passes through this method to the scene.
     
     - Parameters:
        - key: the key that was pressed
     */
    public func keyPressed(key: CalculatorKey) {
        if key == .onoffSwitch {
            if onOffSwitch == .off {
                self.switchToOff()
            } else if onOffSwitch == .calcGame {
                self.switchToCalculator()
            } else if onOffSwitch == .music {
                self.switchToMusic()
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
                    if let key = self.dimensions.keyAt(localLocation) {
                        
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
}
