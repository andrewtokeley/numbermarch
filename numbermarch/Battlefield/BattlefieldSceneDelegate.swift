//
//  BattleSceneDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

protocol BattlefieldSceneDelegate {
    //func battlefieldScene(_ scene: BattlefieldScene, enemyEnteredBattlefield enemy: Enemy)
    //func shouldAddNextEnemy(_scene: BattlefieldScene)
    
    /// Returns the next enemy in the attacking army, if no more enemies exist returns nil
    func nextEnemy() -> Enemy?
    
    /**
     Called when an enemy has invaded the base
     */
    func enemyHasInvaded()
}
