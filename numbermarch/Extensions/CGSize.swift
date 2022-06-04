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
    func offSet(dw: CGFloat, dh: CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
    }
}
