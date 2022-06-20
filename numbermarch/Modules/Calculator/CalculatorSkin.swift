//
//  CalculatorSkin.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 19/06/22.
//

import Foundation
import SpriteKit

protocol CalculatorSkin {
    /**
     Returns the name associated with this calculator, e.g. MG-880
     */
    var name: String { get }
    
    /**
     Long description of the calculator
     */
    var description: String { get }
    
    /**
     The screen width of the skin
     */
    var width: CGFloat { get set }
    
    /**
     The number of characters the screen can display
     */
    var screenSize: Int { get }
    
    /**
     Returns the dimensions of the calculator
     */
    var dimensions: CalculatorDimensions { get }
    
    /**
     Returns the texture representing the calculator image
     */
    var calculatorTexture: SKTexture { get }
    
    /**
     Returns the image representing the calculator
     */
    var image: UIImage? { get }
    
    
    /**
     Returns the text of the switch at a given position
    */
    func switchTexture(_ position: CalculatorSwitchPosition) -> SKTexture

    /**
     If defined, represents the calculator engine that will display the results of standard calculator operations to the screen
     */
    func calculatorEngine(_ screen: ScreenProtocol) -> CalculatorEngine?
    
    /**
     If defined, represents the music engine that will play sounds based on different key presses
     */
    func musicEngine(_ screen: ScreenProtocol) -> MusicEngine?
    
    /**
     If defined, represents the game this calculator plays.
     */
    func gameEngine(_ screen: ScreenProtocol) -> GamesProtocol?
    
    /**
     Returns the key corresponding to the point on the skin's node
     */
    func keyAt(_ point: CGPoint) -> CalculatorKey?
}
