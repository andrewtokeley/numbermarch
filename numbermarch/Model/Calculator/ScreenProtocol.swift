//
//  ScreenProtocol.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

protocol ScreenProtocol {

    /**
     Freezes the characters up to the screenPosition from moving when new characters are appended.
     */
    func freezeCharacters(screenPosition: Int)
    
    /**
     Display a single character to the screen at the given position.
     
     - Parameters:
        - character: charater to display
        - screenPosition: 1 based position on the screen
     */
    func display(_ character: DisplayCharacter, screenPosition: Int)
    
    /**
     Display the characters in the array to the screen starting at the given position.
     
     Note that characters will always be displayed right aligned
     
     - Parameters:
        - screenPosition: the screen position to display the character. The value is 1 based. Where position 1 is the first visible location on the screen.
     */
    func display(_ characters: [DisplayCharacter], screenPosition: Int)

    /**
     Appends a new character to the far right of the screen and shifts any characters that are not fixed to the left.
     */
    func append(_ character: DisplayCharacter)
    
    /**
    Returns the character displayed at the given screen position.
     */
    func characterAt(_ screenPosition: Int) -> DisplayCharacter
}
