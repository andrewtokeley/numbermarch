//
//  CGRectExtensions.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 1/06/22.
//

import Foundation

extension CGRect {
    
    /**
     Returns a rectangle with a size and optionally an origin that is offset from that of the source rectangle.
     */
    func offSet(dw: CGFloat, dh: CGFloat, dx: CGFloat, dy: CGFloat) -> CGRect {
        let newOrigin = CGPoint(x: self.origin.x + dx, y: self.origin.y + dy)
        let newSize = CGSize(width: self.width + dw, height: self.height + dh)
        let rect = CGRect(origin: newOrigin, size: newSize)
        return rect
    }
    
}
