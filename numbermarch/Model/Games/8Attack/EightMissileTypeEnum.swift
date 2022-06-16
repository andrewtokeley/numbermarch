//
//  EightMissileTypeEnum.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/06/22.
//

import Foundation

enum EightMissilleTypeEnum: Int {
    case top
    case middle
    case bottom
    
    /**
     Returns a random EightMissilleTypeEnum not equal to the one provided
     
     This is intended to be used by unit tests only.
     */
    static func not(_ type: EightMissilleTypeEnum) -> EightMissilleTypeEnum {
        if type == .middle { return .top }
        if type == .top { return .bottom }
        if type == .bottom { return .middle }
        return .top
    }
    
    var asDigitalCharacter: DigitalCharacter {
        switch self {
        case .top:
            return DigitalCharacter.missileTop
        case .middle:
            return DigitalCharacter.missileMiddle
        case .bottom:
            return DigitalCharacter.missileBottom
        }
    }
}
