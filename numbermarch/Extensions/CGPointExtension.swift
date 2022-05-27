//
//  CGPointExtension.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 15/05/22.
//

import Foundation

extension CGPoint {
  /// Retuns the point which is an offset of an existing point.
  ///
  /// - Parameters:
  ///   - dx: The x-coordinate offset to apply.
  ///   - dy: The y-coordinate offset to apply.
  ///
  /// - Returns:
  ///   A new point which is an offset of an existing point.
  func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
    return CGPoint(x: x + dx, y: y + dy)
  }
}
