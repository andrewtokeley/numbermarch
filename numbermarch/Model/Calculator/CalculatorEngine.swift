//
//  CalculatorEngine.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 8/06/22.
//

import Foundation

class CalculatorEngine {
    
    var screen: ScreenProtocol

    init(screen: ScreenProtocol) {
        self.screen = screen
    }
    
}

extension CalculatorEngine: KeyboardDelegate {
    func keyPressed(key: CalculatorKey) {
        self.screen.append(DigitalCharacter.eight)
    }
    
    
}
