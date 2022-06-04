//
//  SKNodeExtension.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/05/22.
//

import Foundation
import SpriteKit

enum SKVerticalAlign {
    case top
    case centre
    case bottom
}

enum SKHorizontalAlign {
    case left
    case centre
    case right
}

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

    /**
     Returns whether a node has an anchor at (0,0)
     */
    var isAnchor0x0: Bool {
        var result: Bool
        
        // Only scenes and shapenodes are (or can be) (0,0) anchored
        if let scene = self as? SKScene {
            result = scene.anchorPoint == CGPoint(x: 0, y: 0)
        } else if let spriteNode = self as? SKSpriteNode {
            result = spriteNode.anchorPoint == CGPoint(x: 0, y: 0)
        } else {
            // Unless you're a SKShapeNode your anchor is at (0.5, 0.5)
            result = !(self is SKShapeNode)
        }
        
        return result
    }
    
    /**
     Adds a child node to another node and sets it's position, taking into account their respective anchor points

     - Parameters:
        - verticalAlign: vertical alignment of child within parent
        - horizontalAlign: horizontal alignment of child within parent
        - offSet: offset child's position in either x or y direction
     
     */
    func addChild(_ child: SKNode, verticalAlign: SKVerticalAlign, horizontalAlign: SKHorizontalAlign, offSet: CGVector = CGVector.zero) {
        
        let position = positionForChild(child, verticalAlign: verticalAlign, horizontalAlign: horizontalAlign)
        child.position = CGPoint(x: position.x + offSet.dx, y: position.y + offSet.dy)
        self.addChild(child)
    }
    
    /**
     Returns the position the child node shoud have to be aligned within it's parent node.
     
     Takes into account whether the parent or child is anchored at (0,0) or (0.5, 0.5)
     
     Note that for SKShapeNodes the strokeLine length is part of the node's frame size and will affect the returned position.
     */
    func positionForChild(_ child: SKNode, verticalAlign: SKVerticalAlign, horizontalAlign: SKHorizontalAlign, offSet: CGPoint = CGPoint(x: 0, y: 0)) -> CGPoint {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        // check if parent/child have anchor at (0, 0) or (0.5, 0.5)
        let parentIs0x0 = self.isAnchor0x0
        let childIs0x0 = child.isAnchor0x0
        
        // define x (horizonal align)
        if horizontalAlign == .centre {
            if (parentIs0x0 && childIs0x0) {
                x = self.frame.width/2 - child.frame.width/2
            } else if (parentIs0x0 && !childIs0x0) {
                x = self.frame.width/2
            } else if (!parentIs0x0 && childIs0x0) {
                x = -child.frame.width/2
            } else {
                x = 0
            }
        } else if horizontalAlign == .left {
            if (parentIs0x0 && childIs0x0) {
                x = 0
            } else if (parentIs0x0 && !childIs0x0) {
                x = child.frame.width/2
            } else if (!parentIs0x0 && childIs0x0) {
                x = -self.frame.width/2
            } else {
                x = -self.frame.width/2 + child.frame.width/2
            }
        } else if horizontalAlign == .right {
            if (parentIs0x0 && childIs0x0) {
                x = self.frame.width - child.frame.width
            } else if (parentIs0x0 && !childIs0x0) {
                x = self.frame.width - child.frame.width/2
            } else if (!parentIs0x0 && childIs0x0) {
                x = self.frame.width/2 - child.frame.width
            } else {
                x = self.frame.width/2 - child.frame.width/2
            }
        }
        
        // define y (vertical align)
        if verticalAlign == .centre {
            if (parentIs0x0 && childIs0x0) {
                y = self.frame.height/2 - child.frame.height/2
            } else if (parentIs0x0 && !childIs0x0) {
                y = self.frame.height/2
            } else if (!parentIs0x0 && childIs0x0) {
                y = -child.frame.height/2
            } else {
                y = 0
            }
        } else if verticalAlign == .top {
            if (parentIs0x0 && childIs0x0) {
                y = self.frame.height - child.frame.height
            } else if (parentIs0x0 && !childIs0x0) {
                y = self.frame.height - child.frame.height/2
            } else if (!parentIs0x0 && childIs0x0) {
                y = self.frame.height - child.frame.height
            } else {
                y = self.frame.width/2 - child.frame.width/2
            }
        } else if verticalAlign == .bottom {
            if (parentIs0x0 && childIs0x0) {
                y = 0
            } else if (parentIs0x0 && !childIs0x0) {
                y = child.frame.height/2
            } else if (!parentIs0x0 && childIs0x0) {
                y = -self.frame.height/2
            } else {
                y = -self.frame.height/2 + child.frame.width/2
            }
        }
        
        return CGPoint(x: x + offSet.x, y: y + offSet.y)
    }
}
