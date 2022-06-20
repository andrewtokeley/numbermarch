////
////  CalculatorView.swift
////  numbermarch
////
////  Created by Andrew Tokeley on 28/05/22.
////
////
//
//import UIKit
//import SpriteKit
//import SwiftUI
//import PureLayout
//
////MARK: CalculatorView Class
//final class CalculatorView: UIViewController {
//    
//    // MARK: - Public Properties
//    //private let GAME_SIZE: CGSize = CGSize(width: 300, height: 300)
//    
//    var keyboardDelegate: KeyboardDelegate?
//    
//    // MARK: - Private Properties
//    
//    private var game: GamesProtocol?
//    
//    private var calculatorScene: CalculatorScene? {
//        return calculatorView.scene as? CalculatorScene
//    }
//    
//    // MARK: - UI Elements
//    
//    private lazy var calculatorView: SKView = {
//        let view = SKView()
//        view.allowsTransparency = true
//        view.ignoresSiblingOrder = true
//        view.backgroundColor = .blue
//        return view
//    }()
//    
//    // MARK: - Overrides
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let scene = CalculatorScene(size: view.bounds.size)
//        
//        calculatorView.showsFPS = true
//        calculatorView.showsNodeCount = true
//        calculatorView.ignoresSiblingOrder = false
//        scene.scaleMode = .resizeFill
//        calculatorView.presentScene(scene)
//    }
//    
//    override func loadView() {
//        super.loadView()
//        self.view.backgroundColor = .gameBackground
//        self.view.addSubview(calculatorView)
//        self.setConstraints()
//    }
//    
//    private func setConstraints() {
//        calculatorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
//        calculatorView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
//        calculatorView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
//        calculatorView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
//    }
//    
//    override var shouldAutorotate: Bool {
//        return false
//    }
//    
//    // MARK: - Key Presses
//    
//    override var keyCommands: [UIKeyCommand]? {
//        
//        let left = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyPress))
//        
//        let right = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyPress))
//        
//        let up = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyPress))
//        
//        let down = UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyPress))
//        
//        return [left, right, up, down]
//    }
//    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//    
//    @objc private func keyPress(sender: UIKeyCommand) {
//        if let input = sender.input {
//            switch input {
//            case UIKeyCommand.inputLeftArrow:
//                self.calculatorScene?.keyPressed(key: .point)
//                return
//            case UIKeyCommand.inputRightArrow:
//                self.calculatorScene?.keyPressed(key: .plus)
//                return
//            case UIKeyCommand.inputUpArrow:
//                self.calculatorScene?.keyPressed(key: .game)
//                return
//            case UIKeyCommand.inputDownArrow:
//                self.calculatorScene?.keyPressed(key: .equals)
//                return
//            default: return
//            }
//        }
//    }
//}
