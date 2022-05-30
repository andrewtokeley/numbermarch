//
//  GamesProtocol.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//

import Foundation

/**
 Protocol all games must implement. The CalculatorView will only interact with games through this interface
 */
protocol GamesProtocol {
    func start()
    func stop()
    func pause()
    func resume()
}
