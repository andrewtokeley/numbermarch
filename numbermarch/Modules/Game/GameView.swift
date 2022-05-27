//
//  GameView.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//
//

import UIKit
import SpriteKit
//import Viperit

//MARK: - Public Interface Protocol
protocol GameViewInterface {
    //func displayNewEnemy(enemy: Enemy)
    //func setPlayerValue(value: Int)
    func setGunValue(value: Int)
    func killEnemy(enemy: Enemy)
    func prepareBattlefield(completion: (() -> Void)?)
    func setBattlefieldSpeed(stepTimeInterval: TimeInterval)
    func displayMessage(message: String)
    func displayScore(score: Int)
    func displayLevel(level: Int)
    func displayLives(lives: Int)
    func displayWarDescription(description: String)
    func displayLevelDescription(description: String)
    func advanceEnemies()
}


//MARK: GameView Class
final class GameView: UserInterface {
    
    private let GAME_SIZE: CGSize = CGSize(width: 300, height: 300)
    
    var battlefieldScene: BattlefieldScene? {
        return battlefieldView.scene as? BattlefieldScene
    }
    
    //MARK: - Subviews
    
    lazy var battlefieldView: SKView = {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var newGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Game", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.addTarget(self, action: #selector(newGameClick), for: .touchUpInside)
        return button
    }()
    
    lazy var aimButton: UIButton = {
        let button = UIButton()
        button.setTitle("Aim", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.addTarget(self, action: #selector(aimButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var shootButton: UIButton = {
        let button = UIButton()
        button.setTitle("Shoot", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.addTarget(self, action: #selector(shootButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var pauseResumeButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.gameBattlefieldText, for: .normal)
        button.backgroundColor = .gameBattlefield
        button.addTarget(self, action: #selector(pauseResumeClick), for: .touchUpInside)
        return button
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gameBattlefield
        return label
    }()
    
    lazy var warDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gameBattlefield
        return label
    }()
    
    lazy var levelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gameBattlefield
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gameBattlefield
        label.font = UIFont(name: "Courier", size: 20)
        return label
    }()
    
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gameBattlefield
        label.font = UIFont(name: "Courier", size: 20)
        return label
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "Background")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    // MARK: - Event Handlers
    
    @objc func newGameClick(sender: UIButton) {
        self.battlefieldScene?.displayMessage(message: " 8-016430")
        //self.presenter.didSelectNewGame()
    }
    
    @objc func aimButtonClick(sender: UIButton) {
        let _ = self.battlefieldScene?.gun.aim()
    }
    
    @objc func shootButtonClick(sender: UIButton) {
        if let value = self.battlefieldScene?.gun.value {
            self.presenter.didShoot(value: value)
        }
    }
    
    @objc func pauseResumeClick(sender: UIButton) {
        if (sender.tag == 0) {
            self.battlefieldScene?.pauseEnemies()
            sender.setTitle("Resume", for: .normal)
        } else {
            self.battlefieldScene?.resumeEnemies()
            sender.setTitle("Pause", for: .normal)
        }
        sender.tag = sender.tag == 0 ? 1 : 0
    }
    
    // MARK: - UIViewController overrides
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // at this point the gridView will have been auto sized and the presented scene will have access to its bounds.
        if battlefieldView.scene == nil {
            let scene = BattlefieldScene(size: GAME_SIZE, backgroundColour: .gameBattlefield)
            scene.scaleMode = .aspectFit
            battlefieldView.presentScene(scene)
            scene.battlefieldDelegate = self;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .gameBackground
        self.view.addSubview(backgroundImage)
        self.view.addSubview(battlefieldView)
        self.view.addSubview(newGameButton)
        self.view.addSubview(pauseResumeButton)
        self.view.addSubview(messageLabel)
        self.view.addSubview(warDescriptionLabel)
        self.view.addSubview(levelDescriptionLabel)
        self.view.addSubview(scoreLabel)
        self.view.addSubview(levelLabel)
        
        self.view.addSubview(aimButton)
        self.view.addSubview(shootButton)
        
        self.setConstraints()
    }
    
    private func setConstraints() {
        
        backgroundImage.autoPinEdgesToSuperviewEdges()
        
        battlefieldView.autoPinEdge(toSuperviewEdge: .top, withInset: 300)
        battlefieldView.autoAlignAxis(toSuperviewAxis: .vertical)
        battlefieldView.autoSetDimension(.height, toSize: GAME_SIZE.height)
        battlefieldView.autoSetDimension(.width, toSize: GAME_SIZE.width)
        
        newGameButton.autoPinEdge(.left, to: .left, of: battlefieldView)
        newGameButton.autoPinEdge(toSuperviewEdge: .top, withInset: 150)
        newGameButton.autoSetDimension(.width, toSize: 100)
        
        pauseResumeButton.autoPinEdge(.right, to: .right, of: battlefieldView)
        pauseResumeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 150)
        pauseResumeButton.autoSetDimension(.width, toSize: 100)
        
        levelLabel.autoPinEdge(.left, to: .left, of: battlefieldView)
        levelLabel.autoPinEdge(.bottom, to: .top, of: battlefieldView, withOffset: -10)
        
        scoreLabel.autoPinEdge(.right, to: .right, of: battlefieldView)
        scoreLabel.autoPinEdge(.bottom, to: .top, of: battlefieldView, withOffset: -10)
        
        warDescriptionLabel.autoCenterInSuperview()
        levelDescriptionLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        levelDescriptionLabel.autoPinEdge(.top, to: .bottom, of: warDescriptionLabel, withOffset: 20)
        messageLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        messageLabel.autoPinEdge(.top, to: .bottom, of: levelDescriptionLabel, withOffset: 40)
        
        aimButton.autoPinEdge(.left, to: .left, of: battlefieldView)
        aimButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        aimButton.autoSetDimension(.width, toSize: 100)
        aimButton.autoSetDimension(.height, toSize: 100)
        
        shootButton.autoPinEdge(.right, to: .right, of: battlefieldView)
        shootButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        shootButton.autoSetDimension(.width, toSize: 100)
        shootButton.autoSetDimension(.height, toSize: 100)
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
                let _ = self.battlefieldScene?.gun.aim()
                return
            case UIKeyCommand.inputRightArrow:
                if battlefieldScene?.canShoot ?? false {
                    if let value = battlefieldScene?.aim() {
                        presenter.didShoot(value: value)
                    }
                }
                return
            case UIKeyCommand.inputUpArrow:
                presenter.didSelectNewGame()
            default: return
            }
        }
    }
    
}

extension GameView: BattlefieldSceneDelegate {
    func nextEnemy() -> Enemy? {
        // Ask the presenter to get the next enemy for the battlefield
        return self.presenter.getNextEnemy()
    }
    
    func enemyHasInvaded() {
        self.presenter.enemiesWon()
    }
    
    func shouldAddNextEnemy(_scene: BattlefieldScene) {
        self.presenter.readyForNextEnemy()
    }
}

//MARK: - Public interface
extension GameView: GameViewInterface {
//    func displayNewEnemy(enemy: Enemy) {
//        // TODO - get rid of?
//    }
    
    func displayWarDescription(description: String) {
        self.warDescriptionLabel.text = description
    }
    
    func displayLevelDescription(description: String) {
        self.levelDescriptionLabel.text = description
    }    
    
    func displayLives(lives: Int) {
        self.battlefieldScene?.lives.lives = lives
    }
    
    func displayScore(score: Int) {
        self.scoreLabel.text = String(format: "SCORE: %@", String(score).leftPadding(toLength: 4, withPad: " "))
    }
    
    func displayLevel(level: Int) {
        self.levelLabel.text = String(format: "LEVEL: %@", String(level))
    }
    
    func displayMessage(message: String) {
        self.messageLabel.text = message;
    }
    
    func setBattlefieldSpeed(stepTimeInterval: TimeInterval) {
        self.battlefieldScene?.stepTimeInterval = stepTimeInterval
    }
    
    func prepareBattlefield(completion: (() -> Void)?) {
        self.battlefieldScene?.prepareBattlefield() {
            completion?()
        }
    }
    
    func killEnemy(enemy: Enemy) {
        self.battlefieldScene?.killEnemy(enemy: enemy)
    }
    
    func setGunValue(value: Int) {
        self.battlefieldScene?.gun.value = value
    }
    
    func advanceEnemies() {
        // let the scene know we're ready bring the next enemy
        self.battlefieldScene?.advanceEnemies()
    }
}

// MARK: - VIPER COMPONENTS API (Auto-generated code)
private extension GameView {
    var presenter: GamePresenter {
        return _presenter as! GamePresenter
    }
    var displayData: GameDisplayData {
        return _displayData as! GameDisplayData
    }
}
