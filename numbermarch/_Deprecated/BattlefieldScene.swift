//
//  BattlefieldScene.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import SpriteKit
import GameplayKit
import SwiftUI

/**
 SKScene that contains all the tiles and grid for the game
 */
class BattlefieldScene: SKScene {
        
    // MARK: - Public properties
    
    /// Delegate through which significant events will be communicated
    public var battlefieldDelegate: BattlefieldSceneDelegate?
    
    // MARK: - Private properties
    
    /// Store of each Enemy that's on the battlefield
    private var enemies = [EnemyNode]()
    
    //private var lastEnemyAdded: EnemyNode?
    
    private var isRetreating: Bool = false
    
    /**
     Number of spaces available for characters on the battlefield.
    
     This returned value is the number of enemies visible on the battlefield (``numberOfEnemiesOnBattlefield``) plus three, to make room for a gap, the gun and then the lives indicator.
     */
    private var numberOfSpacesOnBattleField: Int {
        return numberOfEnemiesOnBattlefield + 3
    }
    
    private let livesScreenPosition = 3
    private let gunScreenPosition = 2
    
    /// The number of points an ememy needs to move for one step.
    private var stepIncrement: CGFloat {
        // the screen is split into 'step' spaces for the enemies plus 1 space for the player and another for the lives indicator
        return self.size.width/CGFloat(self.numberOfSpacesOnBattleField)
    }
    
    /// Returns whether the first enemy has reached the lives indicator position
    private var enemiesInvaded: Bool {
        return self.enemies.first?.numberNode.screenPosition == self.numberOfSpacesOnBattleField - self.numberOfEnemiesOnBattlefield
    }
    
    /**
     Based on the number of steps and the width of an enemy. Assumes all enemies are the same width.
     */
    private var enemyEntryStartPoint: CGPoint {
        return positionAtStep(self.numberOfSpacesOnBattleField)
    }
    
    // MARK: - Public Properties
    
    /**
     The number of enemies that are visible on the battlefield.
     
     The default value is 6, but can change this for larger screens
     */
    private var numberOfEnemiesOnBattlefield: Int = 6
    
    /**
     The time interval enemies wait before taking each step.
     
     ```
     // Set interval to 0.5 seconds between steps
     battleField.stepTimeInterval = TimeInterval(0.5)
     ```
     */
    public var stepTimeInterval: TimeInterval = TimeInterval(1.0)
    
    /**
     Speed of enemies, as measured by the time it takes to take one step
     
     Property is deprecated, use ``stepTimeInterval`` instead
     */
    @available(*, deprecated, message: "Use stepTimeInterval instead")
    public var currentSpeed: CGFloat = 50
    
    /**
     Node that represents the player and their lives
     */
    public lazy var gun: GunNode = {
        let player = GunNode(value: 1)
        player.position = positionAtStep(self.gunScreenPosition)
        return player
    }()
    
    /**
     ``DigitalLivesNode`` SKSpriteNode that represents the number of lives left
     */
    public lazy var lives: DigitalLivesNode = {
        let lives = DigitalLivesNode(lives: 3)
        lives.position = positionAtStep(self.livesScreenPosition)
        lives.lives = 3
        return lives
    }()
    
    public var canShoot: Bool {
        return !self.isRetreating
    }
    
    // MARK: - Private Methods
    
    /**
        Returns the screen position for a given step, where step 1 is the first position on the screen
     */
    private func positionAtStep(_ step: Int) -> CGPoint {
        return CGPoint(x: self.stepIncrement * CGFloat(step) - 0.5 * self.stepIncrement, y: self.size.height/2)
    }
    
    /**
     Removes all nodes from the scene
     */
    private func clearScreen() {
        self.removeEnemies()
        self.removeAllChildren()
    }
    
    // MARK: - Initialisation
    
    init(size: CGSize, backgroundColour: UIColor) {
        super.init(size: size)
        self.backgroundColor = backgroundColour
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SKScene Overrides
    
    override func sceneDidLoad() {
        self.scene?.backgroundColor = .gameBattlefield
        
        addChild(self.gun)
        addChild(self.lives)

    }
    
    // MARK: - Public Methods
    
    /**
     Displays numbers and spaces to the screen. Display is always right aligned.
     
     Note you can only display the numbers 0 to 9 and spaces, all other characters will be ignored.
     
     Additionally, if the number of characters in the message exceed the space on the screen as indicated by ``numberOfSpacesOnBattleField``, they will not be displayed
     */
    public func displayMessage(message: String) {
        
        // clear the battlefield
        self.clearScreen()
        
        // 1 base position to place character on screen. Start at the far right.
        var position = self.numberOfSpacesOnBattleField
        var charIndex = message.count - 1
        while charIndex >= 0 {
            var value = DisplayCharacter.space.rawValue
            let char = message[charIndex]
            
            if char.isNumber {
                value = Int(String(char)) ?? DisplayCharacter.space.rawValue
            } else {
                // only characters allowed are space and hyphen
                if char == " " {
                    value = DisplayCharacter.space.rawValue
                } else if char == "-" {
                    value = DisplayCharacter.onebar.rawValue
                }
            }
            
            // create a node to represent character
            let node = DigitalCharacterNode(value: value)
            node.position = self.positionAtStep(position)
            self.addChild(node)
            
            position -= 1
            charIndex -= 1
        }
    }
    
    /**
     Initiates the game loop to march enemies each step, add new enemies and repeat.
     
     - Parameters:
        - addFirst: if true, each iteration will first add a new enemy (if one exists) and then march the enemies all forward. Otherwise, new enemies are added after the march step. This is useful when restarting the march after killing an enemy and retreating other enemies. In this case you want to move first then add. If you have started a new battle then you need to add first.
     */
    public func advanceEnemies(addFirst: Bool = true) {

        // if another enemy is ready to come into battle, bring it in
        if addFirst {
            if let enemy = self.battlefieldDelegate?.nextEnemy() {
                self.addEnemy(enemy: enemy)
            }
        }

        // move all enemies one step
        self.moveEnemies(enemies: self.enemies) {
            
            // check to see if the enemes have invaded
            if self.enemiesInvaded {
                self.battlefieldDelegate?.enemyHasInvaded()
            } else {
                // rinse and repeat
                self.advanceEnemies()
            }
        }
    }
    
    /**
     Kill the enemy, removing them from the battlefield and retreating any enemies that are ahead of it.
     */
    public func killEnemy(enemy: Enemy) {
        
        // find the enemyNode for victim
        if let index = self.enemies.firstIndex(where: { $0.enemy.id == enemy.id }) {
            
            // record that we're in the middle of a retreat
            self.isRetreating = true
            
            // EnemyNode of the victim
            let victimEnemy = self.enemies[index]
            
            // remove actions from active enemies (this will stop them)
            self.removeEnemyActions(enemies: self.enemies)
            
            // fade the victim as it dies
            let fade = SKAction.fadeOut(withDuration: TimeInterval(0.1))
            victimEnemy.numberNode.run(fade) {
                    
                // remove the victim from the battlefield
                victimEnemy.numberNode.removeFromParent()
                
                // remove victim from enemies list
                self.enemies.remove(at: index)
                
                // retreat the more advanced enemies into the gap left by the victim
                self.retreatEnemies(fromIndex: index, distance: self.stepIncrement, speed: 2000) {
                    
                    // mark as retreating so to prevent shooting other enemies mid retreat
                    self.isRetreating = false
                    
                    // re-advance all the enemies to get the march going again
                    let addNewEnemyBeforeMoving = self.enemies.count == 0 ? true : false
                    self.advanceEnemies(addFirst: addNewEnemyBeforeMoving)
                }
            }
            
        } else {
            print("can't find enemy")
            print("thought i shot \(enemy.id), value \(enemy.value)")
            print("but only active enemies are...")
            for enemy in enemies {
                print("\(enemy.enemy.id), value \(enemy.enemy.value)")
            }
        }
    }
    
    /**
     Called by parent to aim the gun and increment its value
     */
    public func aim() -> Int {
        return self.gun.aim()
    }
    
    /**
     Clears the battlefield ready for another battle, removing any enemies from the battlefield. Note this method doesn't start the enemy advance, you must explicitly call ``advanceEnemies()`` for this).
     */
    public func prepareBattlefield(completion: (() -> Void)?) {
        self.isRetreating = true
        self.removeEnemies()
        self.isRetreating = false
        self.isPaused = false
        completion?()
    }
    
    public func pauseEnemies() {
        self.pauseEnemies(enemies: self.enemies)
    }
    
    public func resumeEnemies() {
        self.resumeEnemies(enemies: self.enemies)
    }
    
    // MARK: - Private Methods
    
    /**
     Adds a new enemy to the battlefield
     */
    private func addEnemy(enemy: Enemy) {
        
        //guard enemiesPaused != true else { return }
        
        // create a node to match this enemy
        let enemyNode = DigitalCharacterEnemy(enemy: enemy)
        
        self.enemies.append(enemyNode)
        
        enemyNode.numberNode.position = self.enemyEntryStartPoint
        enemyNode.numberNode.screenPosition = self.numberOfSpacesOnBattleField
        enemyNode.numberNode.zPosition = 0
        
        addChild(enemyNode.numberNode)
        
    }
    
    /// Remove all enemies from the battlefield - typically done to prepare for a new battle or reset after they've invaded
    private func removeEnemies() {
        
        for enemy in self.enemies {
            enemy.numberNode.removeAllActions()
            enemy.numberNode.removeFromParent()
        }
        self.enemies.removeAll()
    }
    
    private func retreatEnemies(fromIndex: Int, distance: CGFloat, speed: CGFloat, completion: (() -> Void)?) {
        
        if fromIndex > 0 {
            let enemies = self.enemies[0...fromIndex - 1]
            let group = DispatchGroup()
            
            for enemy in enemies {
                group.enter()
                retreatEnemy(enemy: enemy, distance: distance, speed: speed) {
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    private func retreatEnemy(enemy: EnemyNode, distance: CGFloat, speed: CGFloat = 200, completion: (() -> Void)?) {
        
        // retreat the enemy back a given distance
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: distance, y: 0))
        
        let action = SKAction.follow(linePath.cgPath, asOffset: true, orientToPath: false, speed: speed)
        enemy.numberNode.run(action) {
            enemy.numberNode.screenPosition += 1
            completion?()
        }
    }
    
    private func pauseEnemies(enemies: [EnemyNode]) {
        for enemy in enemies {
            enemy.numberNode.isPaused = true
        }
    }
    
    private func resumeEnemies(enemies: [EnemyNode]) {
        for enemy in enemies {
            enemy.numberNode.isPaused = false
        }
    }
    
    private func removeEnemyActions(enemies: [EnemyNode]) {
        for enemy in enemies {
            enemy.numberNode.removeAllActions()
        }
    }
    
    /**
     Moves an enemy one step
     */
    private func moveEnemy(enemy: EnemyNode, completion: (() -> Void)?) {
        
        let stepAction = SKAction.move(by: CGVector(dx: -self.stepIncrement, dy: 0), duration: TimeInterval(0))
        let recordStep = SKAction.run {
            enemy.numberNode.screenPosition -= 1
        }

        let wait = SKAction.wait(forDuration: self.stepTimeInterval)
        
        let step = SKAction.sequence([wait, stepAction, recordStep])
        
        enemy.numberNode.run(step) {
            completion?()
        }
    
    }
    
    /**
     Moves all enemies one step
     */
    private func moveEnemies(enemies: [EnemyNode], completion: (() -> Void)? = nil) {
        
        if self.enemies.count == 0 {
            completion?()
        }
        
        let dispatch = DispatchGroup()
        
        for enemy in enemies {
            dispatch.enter()
            self.moveEnemy(enemy: enemy) {
                dispatch.leave()
            }
        }
        dispatch.notify(queue: .main) {
            completion?()
        }
    }
    
    
}
