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
    
    private var screenScene: ScreenScene? {
        return screenView.scene as? ScreenScene
    }
    
    // MARK: - UI Elements
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "Background")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var screenView: SKView = {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        view.backgroundColor = .blue
        return view
    }()

    private lazy var gameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Game", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.tag = CalculatorKey.game.rawValue
        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var aimButton: UIButton = {
        let button = UIButton()
        button.setTitle("Aim", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.tag = CalculatorKey.point.rawValue
        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var shootButton: UIButton = {
        let button = UIButton()
        button.setTitle("Shoot", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.tag = CalculatorKey.plus.rawValue
        button.addTarget(self, action: #selector(keyboardButtonClick), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Overrides
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // at this point the gridView will have been auto sized and the presented scene will have access to its bounds.
        if screenView.scene == nil {
            let scene = ScreenScene(numberOfCharacters: 9, size: GAME_SIZE)
            scene.scaleMode = .aspectFit
            scene.backgroundColor = .gameBattlefield
            screenView.presentScene(scene)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .gameBackground
        self.view.addSubview(backgroundImage)
        self.view.addSubview(aimButton)
        self.view.addSubview(shootButton)
        self.view.addSubview(screenView)
        self.view.addSubview(gameButton)
        self.setConstraints()
    }
    
    private func setConstraints() {
        
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
        screenView.autoPinEdge(toSuperviewEdge: .top, withInset: 300)
        screenView.autoAlignAxis(toSuperviewAxis: .vertical)
        screenView.autoSetDimension(.height, toSize: GAME_SIZE.height)
        screenView.autoSetDimension(.width, toSize: GAME_SIZE.width)
        
        aimButton.autoPinEdge(.left, to: .left, of: screenView)
        aimButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        aimButton.autoSetDimension(.width, toSize: 100)
        aimButton.autoSetDimension(.height, toSize: 100)
        
        gameButton.autoPinEdge(.left, to: .right, of: aimButton, withOffset: 10)
        gameButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        gameButton.autoSetDimension(.width, toSize: 100)
        gameButton.autoSetDimension(.height, toSize: 100)
        
        shootButton.autoPinEdge(.right, to: .right, of: screenView)
        shootButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        shootButton.autoSetDimension(.width, toSize: 100)
        shootButton.autoSetDimension(.height, toSize: 100)
    }
    
    // MARK: - Public Methods
    
    /**
    Creates a new instance of SpaceInvaders game and calls it's start method.
     */
    private func startGame() {
        var result: GamesProtocol?
        if let screen = self.screenScene {
            result = SpaceInvaders(screen: screen, warRules: SpaceInvadersWarRules(), battleRules: SpaceInvaderBattleRules())
            self.keyboardDelegate = result as? KeyboardDelegate
        }
        result?.start()
    }
    
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
                self.keyboardDelegate?.keyPressed(key: .point)
                return
            case UIKeyCommand.inputRightArrow:
                self.keyboardDelegate?.keyPressed(key: .plus)
                return
            case UIKeyCommand.inputUpArrow:
                self.startGame()
                return
            default: return
            }
        }
    }
    
    @objc private func keyboardButtonClick(sender: UIButton) {
        if let key = CalculatorKey(rawValue: sender.tag) {
            switch key {
            case .game:
                self.startGame()
            default:
                self.keyboardDelegate?.keyPressed(key: key)
            }
        }
    }
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

