//
//  BattleFactory.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

class WarFactory {
    static let sharedInstance = WarFactory()
    
    var runningInTestMode: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    lazy var warService: WarServiceInterface = {
        return WarService()
    }()
}
