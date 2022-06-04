//
//  CGSize.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 1/06/22.
//

import Foundation

extension CGSize {
    
    /**
     Returns a size object that is offset by the delta width and height values
     */
    func offSetBy(dw: CGFloat, dh: CGFloat) -> CGSize {
        return CGSize(width: self.width + dw, height: self.height + dh)
    }
}
