//
//  CGRectExtensions.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 1/06/22.
//

import Foundation

extension CGRect {
    
    /**
     Returns a rectangle with a size and origin that is offset from that of the source rectangle.
     */
    func offSetBy(dx: CGFloat, dy: CGFloat, dw: CGFloat, dh: CGFloat) -> CGRect {
        let newOrigin = self.origin.offsetBy(dx: dx, dy: dy)
        let newSize = self.size.offSetBy(dw: dw, dh: dh)
        let rect = CGRect(origin: newOrigin, size: newSize)
        return rect
    }
    
}
