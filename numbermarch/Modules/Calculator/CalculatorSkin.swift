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
     This is the preferred method of initialising a CalculatorSkin
     
     - Parameters:
        -width: the width of the calculator on the screen it is being displayed in. This is used to transform the skin's actual dimensions into screen dimensions.
     */
    init(width: CGFloat)
    
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
     If defined, the number engine that handles input from the calculator - typically either a CalculatorEngine or a MusicEngine (MG-880)
     */
    func engineForSwitchPosition(_ switchPosition: CalculatorSwitchPosition, screen: ScreenProtocol) -> NumberEngine?
    
    /**
     If defined, returns the game that can be played on the screen
     */
    func game(_ screen: ScreenProtocol) -> GamesProtocol?
    
    /**
     Returns the key corresponding to the point on the skin's node
     */
    func keyAt(_ point: CGPoint) -> CalculatorKey?
    
    /**
     Returns the subtext at a given position
     */
    func subText(_ position: Int) -> String?
}

// MARK: - Protocol Extension - Default Implementations

/**
 Protocol Extension to provide default implementations
 */
extension CalculatorSkin {
    
    /**
    Allows for skins to be created without supplying a width.
     
    While you don't have to initialise the skin with a width, you must still set the width property in order for the dimensions property to return relevant measurements.
     */
    init(width: CGFloat = 100) {
        self.init(width: width)
    }
    
    func subText(_ position: Int) -> String? {
        return nil
    }
    
    func engineForSwitchPosition(_ switchPosition: CalculatorSwitchPosition) -> NumberEngine? {
        return nil
    }
    
    func switch1NumberEngine(_ screen: ScreenProtocol) -> NumberEngine? {
        return nil
    }
    
    func switch2Function(_ screen: ScreenProtocol) -> NumberEngine? {
        return nil
    }
    
    func game(_ screen: ScreenProtocol) -> GamesProtocol? {
        return nil
    }
    
}
