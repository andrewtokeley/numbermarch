//
//  MainView.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//
//

import UIKit
import Viperit
import SpriteKit
import PureLayout

//MARK: MainView Class
final class MainView: UserInterface {
    
    // MARK: - Public Properties
    //private let GAME_SIZE: CGSize = CGSize(width: 300, height: 300)
    
    var keyboardDelegate: KeyboardDelegate?
    
    // MARK: - Private Properties
    
    private var game: GamesProtocol?
    
    private var skin: CalculatorSkin?
    
    private var calculatorScene: CalculatorScene? {
        return calculatorView.scene as? CalculatorScene
    }
    
    // MARK: - UI Elements
    
    private lazy var calculatorView: SKView = {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        return view
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(calculatorView)
        self.setConstraints()
    }
    
    private func setConstraints() {
        calculatorView.autoPinEdgesToSuperviewSafeArea()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Key Presses
    
    override var keyCommands: [UIKeyCommand]? {
        
        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
        
        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
        
        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
        
        let down = UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyPress))
        
        return [left, right, up, down]
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
            case UIKeyCommand.inputDownArrow:
                self.calculatorScene?.keyPressed(key: .equals)
                return
            default: return
            }
        }
    }
}

//MARK: - MainView API
extension MainView: MainViewApi {
    
    func displayTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func displayCalculator(_ calculator: CalculatorSkin) {
        
        var skin = calculator
        skin.width = view.bounds.size.width * 0.95
        let scene = CalculatorScene(size: view.bounds.size, skin: skin)
        
        calculatorView.showsFPS = true
        calculatorView.showsNodeCount = true
        calculatorView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        calculatorView.presentScene(scene)
        
    }
}

// MARK: - MainView Viper Components API
private extension MainView {
    var presenter: MainPresenterApi {
        return _presenter as! MainPresenterApi
    }
    var displayData: MainDisplayData {
        return _displayData as! MainDisplayData
    }
}
