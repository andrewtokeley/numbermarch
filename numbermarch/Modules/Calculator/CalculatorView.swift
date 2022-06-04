//
//  CalculatorView.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//
//

import UIKit
import SpriteKit
import SwiftUI

//MARK: CalculatorView Class
final class CalculatorView: UserInterface {
    
    // MARK: - Public Properties
    private let GAME_SIZE: CGSize = CGSize(width: 300, height: 300)
    
    var keyboardDelegate: KeyboardDelegate?
    
    // MARK: - Private Properties
    
    private var game: GamesProtocol?
    
    private var calculatorScene: CalculatorScene? {
        return calculatorView.scene as? CalculatorScene
    }
    
    // MARK: - UI Elements
    
//    lazy var backgroundImage: UIImageView = {
//        let image = UIImage(named: "Background")
//        let imageView = UIImageView(image: image)
//        return imageView
//    }()
    
    private lazy var calculatorView: SKView = {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        view.backgroundColor = .blue
        return view
    }()

//    private lazy var gameButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Game", for: .normal)
//        button.setTitleColor(.gameBattlefieldText, for: .normal)
//        button.backgroundColor = .gameBattlefield
//        button.tag = CalculatorKey.game.rawValue
//        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var aimButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Aim", for: .normal)
//        button.setTitleColor(.gameBattlefieldText, for: .normal)
//        button.backgroundColor = .gameBattlefield
//        button.tag = CalculatorKey.point.rawValue
//        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var shootButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Shoot", for: .normal)
//        button.setTitleColor(.gameBattlefieldText, for: .normal)
//        button.backgroundColor = .gameBattlefield
//        button.tag = CalculatorKey.plus.rawValue
//        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
//        return button
//    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = CalculatorScene(size: view.bounds.size)
        
        calculatorView.showsFPS = true
        calculatorView.showsNodeCount = true
        calculatorView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        calculatorView.presentScene(scene)
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .gameBackground
        self.view.addSubview(calculatorView)
        self.setConstraints()
    }
    
    private func setConstraints() {
        calculatorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        calculatorView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        calculatorView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        calculatorView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
    }
    
    // MARK: - Public Methods
    
    /**
    Creates a new instance of SpaceInvaders game and calls it's start method.
     */
//    private func startGame() {
//        var game: GamesProtocol?
//        if let screen = self.calculatorScene?.screen {
//            game = SpaceInvaders(screen: screen, warRules: SpaceInvadersWarRules(), battleRules: SpaceInvaderBattleRules())
//
//            // if the game can be a keyboard delegate (which it needs to in order to react to keypresses), then assign it to the delegate
//            self.calculatorScene?.keyboardDelegate = game as? KeyboardDelegate
//        }
//        game?.start()
//    }
    
    // MARK: - Key Presses
    
    override var keyCommands: [UIKeyCommand]? {
        
        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
        
        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
        
        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
        
        return [left, right, up]
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc private func keyPress(sender: UIKeyCommand) {
        if let input = sender.input {
            switch input {
            case UIKeyCommand.inputLeftArrow:
                self.calculatorScene?.keyPressed(key: .point)
                return
            case UIKeyCommand.inputRightArrow:
                self.calculatorScene?.keyPressed(key: .plus)
                return
            case UIKeyCommand.inputUpArrow:
                self.calculatorScene?.keyPressed(key: .game)
                return
            default: return
            }
        }
    }
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
}

//MARK: - CalculatorView API
extension CalculatorView: CalculatorViewApi {
}

// MARK: - CalculatorView Viper Components API
private extension CalculatorView {
    var presenter: CalculatorPresenterApi {
        return _presenter as! CalculatorPresenterApi
    }
    var displayData: CalculatorDisplayData {
        return _displayData as! CalculatorDisplayData
    }
}

