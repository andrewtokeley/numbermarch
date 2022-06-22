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

    // MARK: - Public Properties
    
    /**
     Determines whether to show a faint grey border around each character cell.
     */
    var showCellBorders: Bool { get set }
    
    /**
    The number of characters the screen can display
     */
    var numberOfCharacters: Int { get }

    /**
     Returns whether appending another character will cause the far left character to "fall" off the screen because the screen is full.
     */
    var canAppendWithoutLoss: Bool { get }
    /**
     Returns what is displayed on the screen as a number.
     
     If the characters on the screen don't represent a number, nil is returned.
     */
    var asNumber: NSNumber? { get }
    
    /**
     Freezes the characters up to the screenPosition from moving when new characters are appended.
     */
    func freezeCharacters(screenPosition: Int)
    
    /**
     Clears the screen, including any messages being displayed
     
     - Parameters:
        - includingMessageText: if true the message text will also be cleared. Default is true.
     */
    func clearScreen(includingMessageText: Bool)
    
    // MARK: - Display Methods
    
    /**
     Display an operation symbol on the screen. This will appear on the top right of the screen and always in the order /, *, -, +
     */
    func displayOperationSymbol(_ symbol: OperationSymbol)
    
    /**
     Displays a decimal point at the given position. The position is to the right of where digits are rendered at the same position.
     
     - Parameters:
        - screenPosition: the position on the screen to draw the decimal. Default value is the far right of the screen.
        - makeUnique: if true, any other decimal point(s) on the screen will be removed. Default is true.
     */
    func displayDecimalPoint(_ screenPosition: Int, makeUnique: Bool)
    
    /**
     Display a single character to the screen at the given position.
     
     - Parameters:
        - character: charater to display
        - screenPosition: 1 based position on the screen. Default value is the far right of the screen.
     */
    func display(_ character: DigitalCharacter, screenPosition: Int)
    
    /**
     Display the characters in the array to the screen starting at the given position.
     
     Note that characters will always be displayed right aligned
     
     - Parameters:
        - character: charater to display
        - screenPosition: the screen position to display the character. The value is 1 based. Where position 1 is the first visible location on the screen. Default value is the far right of the screen.
        - delay: time to wait before the completion handler is called. Default is TimeInterval(0).
        - completion: handler to call after delay. Default is nil
     */
    func display(_ characters: [DigitalCharacter], screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?)
    
    /**
     Display the string, right aligned, to the screen starting at the given position.
     
     Note that only characters able to be represented on the screen will be displayed. Unrecognised characters will display as a space.
     
     - Parameters:
        - string: the text to display
        - screenPosition: the screen position to display the character. The value is 1 based. Where position 1 is the first visible location on the screen.  The default is the last position on the screen.
        - delay: the number of seconds to wait before calling the completion handler. If no completion handler has been set, this argument is ignored.
        - completion: optional completion handler
     */
    func display(_ string: String, screenPosition: Int, delay: TimeInterval, completion: (() -> Void)?)
    
    /**
     Display the number, right aligned, to the screen
     
     Numbers will be rounded to fit within the number of characters on the screen (``numberOfCharacters``)
     
     If the number can not be displayed on the screen it will be abbreviated using E notation (TODO!)
     
     - Parameters:
        - number: number to display
     */
    func display(_ number: Double)
    
    /**
     Displays a textual message on the screen
     */
    func displayTextMessage(text: String)
    
    /**
     Displays a subtext character at the given position
     */
    func displaySubText(text: String, position: Int)
    
    // MARK: - Append Methods
    
    /**
     Appends a new character to the far right of the screen and shifts any characters that are not fixed to the left.
     */
    func append(_ character: DigitalCharacter, delay: TimeInterval, completion: (() -> Void)?)
    
    /**
     Appends a decimal place to the end of the screen
     */
    func appendDecimalPoint()
    
    // MARK: - Remove Methods
    
    /**
     Removes the character at the given screen postion
     */
    func remove(screenPosition: Int)
    
    /**
     Remove decimal point from position
     */
    func removeDecimalPoint(_ screenPosition: Int)
    
    // MARK: - Search Methods
    
    /**
    Returns the character displayed at the given screen position.
     */
    func characterAt(_ screenPosition: Int) -> DigitalCharacter?
    
    /**
     Finds the position of the first occurance of the character on the screen, searching from left to right
     */
    func findPosition(_ character: DigitalCharacter, fromPosition: Int) -> Int?
}

// MARK: - ScreenProtocol, Default Implementations

extension ScreenProtocol {
    
    func clearScreen(includingMessageText: Bool = true) {
        clearScreen(includingMessageText: includingMessageText)
    }
    
    func displayDecimalPoint(_ screenPosition: Int = -1, makeUnique: Bool = true) {
        let position = screenPosition == -1 ? self.numberOfCharacters : screenPosition
        displayDecimalPoint(position, makeUnique: makeUnique)
    }
    
    func append(_ character: DigitalCharacter, delay: TimeInterval = TimeInterval(0), completion: (() -> Void)? = nil) {
        append(character, delay: delay, completion: completion)
    }
    
    func display(_ string: String, screenPosition: Int = -1, delay: TimeInterval = TimeInterval(0), completion: (() -> Void)? = nil) {
        let position = screenPosition == -1 ? self.numberOfCharacters : screenPosition
        display(string, screenPosition: position, delay: delay, completion: completion)
    }
    
    func display(_ characters: [DigitalCharacter], screenPosition: Int = -1, delay: TimeInterval = TimeInterval(0), completion: (() -> Void)? = nil) {
        let position = screenPosition == -1 ? self.numberOfCharacters : screenPosition
        display(characters, screenPosition: position, delay: delay, completion: completion)
    }
    
}
