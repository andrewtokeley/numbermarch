//
//  ScreenProtocol.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

/**
 All screen implementations must implement these methods
 */
protocol ScreenProtocol {

    /**
    The number of characters the screen can display
     */
    var numberOfCharacters: Int { get }

    /**
     Freezes the characters up to the screenPosition from moving when new characters are appended.
     */
    func freezeCharacters(screenPosition: Int)
    
    /**
     Clears the screen
     */
    func clearScreen() 
    
    /**
     Display a single character to the screen at the given position.
     
     - Parameters:
        - character: charater to display
        - screenPosition: 1 based position on the screen
     */
    func display(_ character: DigitalCharacter, screenPosition: Int)
    
    /**
     Display the characters in the array to the screen starting at the given position.
     
     Note that characters will always be displayed right aligned
     
     - Parameters:
        - screenPosition: the screen position to display the character. The value is 1 based. Where position 1 is the first visible location on the screen.
     */
    func display(_ characters: [DigitalCharacter], screenPosition: Int)
    func display(_ characters: [DigitalCharacter], screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?)
    
    /**
     Display the string to the screen starting at the given position.
     
     Note that only characters able to be represented on the screen will be displayed.
     
     - Parameters:
        - string: the text to display
        - screenPosition: the screen position to display the character. The value is 1 based. Where position 1 is the first visible location on the screen.
     */
    func display(_ string: String, screenPosition: Int)
    func display(_ string: String, screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?)
    /**
     Appends a new character to the far right of the screen and shifts any characters that are not fixed to the left.
     */
    func append(_ character: DigitalCharacter)
    func append(_ character: DigitalCharacter, delay: TimeInterval, completion: (() -> Void)?)
    
    /**
     Removes the character at the given screen postion
     */
    func remove(screenPosition: Int)
    
    /**
     Displays a textual message on the screen
     */
    func displayTextMessage(text: String)
    
    /**
    Returns the character displayed at the given screen position.
     */
    func characterAt(_ screenPosition: Int) -> DigitalCharacter
    
    /**
     Finds the position of the first occurance of the character on the screen, searching from left to right
     */
    func findPosition(_ character: DigitalCharacter, fromPosition: Int) -> Int?
}
