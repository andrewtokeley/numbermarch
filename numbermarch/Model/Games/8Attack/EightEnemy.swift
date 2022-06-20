//
//  EightEnemy.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/06/22.
//

import Foundation

/**
 The direction the enemy is moving
 */
enum EightDirection: Int {
    case left = -1
    case right = 1
    
    var opposite: EightDirection {
        return self == .left ? .right : .left
    }
}

/**
 The shape type of the enemy
 */
enum EightEnemyType: Int {
    case topMissing = 0
    case middleMissing = 1
    case bottomMissing = 2
    /**
     Special H shaped mothership that is worth extra points
     */
    case mothership = 3
    
    /**
     Returns a random (non mothership) type
     */
    static func random() -> EightEnemyType {
        let random = Int.random(in: 0..<3)
        return EightEnemyType(rawValue: random)!
    }
    
    /**
     Returns a random EightEnemyType not equal to self (and also not a mothership)
     */
    func not() -> EightEnemyType {
        var new: EightEnemyType = .topMissing
        while new == self {
            new = EightEnemyType.random()
        }
        return new
    }
    
    /**
     Returns whether the given missile will complete the enemy
     */
    func isCompletedBy(_ missileType: EightMissilleTypeEnum) -> Bool {
        if self == .topMissing && missileType == .top { return true }
        if self == .middleMissing && missileType == .middle { return true }
        if self == .bottomMissing && missileType == .bottom { return true }
        // Anything can kill a mothership
        if self == .mothership { return true }
        return false
    }
    
    /**
     Only used for testing purposes to guarantee a kill
     */
    var canBeKilledByMissleType: EightMissilleTypeEnum {
        if self == .topMissing { return .top }
        if self == .middleMissing { return .middle }
        if self == .bottomMissing { return .bottom }
        if self == .mothership { return .middle }
        return .middle
    }
    
    /**
     Returns a digital character representation of the enemy
     */
    var asDigitalCharacter: DigitalCharacter {
        switch self {
        case .topMissing:
            return DigitalCharacter.upsideDownA
        case .bottomMissing:
            return DigitalCharacter.A
        case .mothership:
            return DigitalCharacter.H
        case .middleMissing:
            return DigitalCharacter.zero
        }
    }

}

/**
 Represents an enemy
 */
class EightEnemy {
    
    var type: EightEnemyType
    var direction: EightDirection
    var position: Int = 0
    var isDead: Bool
    
    init(type: EightEnemyType, direction: EightDirection) {
        self.type = type
        self.direction = direction
        self.isDead = false
    }

    var asText: String {
        if type == .topMissing { return "V" }
        if type == .bottomMissing { return "A" }
        if type == .middleMissing { return "O" }
        if type == .mothership { return "8" }
        return ""
    }
    
//    var asDigitalCharacter: DigitalCharacter {
//        switch self.type {
//        case .topMissing:
//            return DigitalCharacter.upsideDownA
//        case .bottomMissing:
//            return DigitalCharacter.A
//        case .complete:
//            return DigitalCharacter.eight
//        case .middleMissing:
//            return DigitalCharacter.zero
//        }
//    }
}
