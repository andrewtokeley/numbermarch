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
    
    /**
     Ratio between height an width is 10:6
     */
    private var CALC_HEIGHT: CGFloat {
        return CALC_WIDTH * 10/6
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.backgroundColor = .black
        
        self.addChild(calculatorBackground, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -100))

        self.calculatorBackground.addChild(self.screenOuterBorder, verticalAlign: .top, horizontalAlign: .left)
        
        self.screenOuterBorder.addChild(self.screen, verticalAlign: .top, horizontalAlign: .centre, offSet: CGVector(dx: 0, dy: -GAP))
        
        // keys
//        self.calculatorBackground.addChild(self.aimKey, verticalAlign: .bottom, horizontalAlign: .left, offSet: CGVector(dx: 3 * GAP, dy: 2 * GAP))
        self.calculatorBackground.addChild(self.aimKey, verticalAlign: .top, horizontalAlign: .left)
        self.calculatorBackground.addChild(self.shootKey, verticalAlign: .bottom, horizontalAlign: .right, offSet: CGVector(dx: -3 * GAP, dy: 2 * GAP))
        
    }
    
    public lazy var calculatorBackground: SKSpriteNode   = {
//        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: CALC_WIDTH, height: CALC_HEIGHT), cornerRadius: 0.01 * CALC_WIDTH)
//        node.fillColor = .calculatorBackground
        let node = SKSpriteNode(color: .red, size: CGSize(width: CALC_WIDTH, height: CALC_HEIGHT))
//        let node = SKSpriteNode(texture: SKTexture(imageNamed: "Background"), size: CGSize(width: CALC_WIDTH, height: CALC_HEIGHT))
        //node.scale(to: node.size)
        return node
    }()
    
    public lazy var screenOuterBorder: SKShapeNode = {
        let height = CALC_HEIGHT / 4
        let width = CALC_WIDTH - 4 * GAP
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 0.05*height)
        node.fillColor = UIColor.calculatorScreenOuterBorder
        node.strokeColor = .black
        return node
    }()
    
    public lazy var screen: ScreenNode = {
        let height = CALC_HEIGHT / 4 - 3 * GAP
        let width = CALC_WIDTH - 8 * GAP
        let node = ScreenNode(numberOfCharacters: 9, size: CGSize(width: width, height: height))
        //node.position = CGPoint(x: CALC_WIDTH/2, y: CALC_HEIGHT-0.5 * height - 6 * GAP)
        node.display("08-016430", screenPosition: 1)
        node.displayTextMessage(text: "GAME OVER")
        return node
    }()
    
    private lazy var aimKey: KeyNode = {
        let node = KeyNode(key: .point, keyColor: .calculatorKeyBlue)
        return node
    }()
    
    private lazy var shootKey: KeyNode = {
        let node = KeyNode(key: .plus, keyColor: .calculatorKeyGray)
        return node
    }()
}
