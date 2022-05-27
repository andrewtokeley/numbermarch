//
//  AppModules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation

//MARK: - Application modules
enum AppModules: String, ViperitModule {
    case game
    case loader
    var viewType: ViperitViewType {
        if self == .loader {
            return .storyboard
        } else {
            return .code
        }
    }
}
