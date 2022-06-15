//
//  Decimal.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//

import Foundation

extension Decimal {
    func formatAsString(length: Int) {
        let formater = NumberFormatter()
        formater.formatWidth = length
    }
}
