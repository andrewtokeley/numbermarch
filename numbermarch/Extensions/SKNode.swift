//
//  SKNodeExtension.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/05/22.
//

import Foundation
import SpriteKit

extension SKNode
{
    func run(action: SKAction!, withKey: String!, optionalCompletion:(() -> Void)?) {
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([ action, completionAction ])
            run(compositeAction, withKey: withKey )
        }
        else
        {
            run( action, withKey: withKey )
        }
    }

    func actionForKeyIsRunning(key: String) -> Bool {
        return self.action(forKey: key) != nil ? true : false
    }
}
