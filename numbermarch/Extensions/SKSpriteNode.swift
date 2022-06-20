//
//  SKSpriteNode.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 17/06/22.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    func addChild(_ node: SKSpriteNode, skewValue: CGFloat = -1) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.shouldEnableEffects = true
        effectNode.addChild(node)
        effectNode.zPosition = 1
        let transform = CGAffineTransform(a:  1,            b:  0,
                                          c:  skewValue,    d:  1,
                                          tx: 0,            ty: 0)
        let transformFilter = CIFilter(name: "CIAffineTransform")!
        transformFilter.setValue(transform, forKey: "inputTransform")
        effectNode.filter = transformFilter
        addChild(effectNode)
        texture = nil
    }
}
