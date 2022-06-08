//
//  WarDelegate.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 7/06/22.
//

import Foundation

protocol WarDelegate {
    
    /**
     Called when a new battle is ready to advance onto the battlefield. This is typically in response to a client calling ``startWar`` or ``moveToNextBattle`` on a ``War`` instance.
     
     - Parameters:
        - war: ``War`` instance
        - newBattle: ``Battle`` instance of the battle that is ready to advance onto the battlefield
     */
    func war(_ war: War, newBattle battle: Battle)
    
    /**
    Called when all battles have been fought and the war is over.
     */
    func war(_ war: War, warWonWithScore score: Int)
}
