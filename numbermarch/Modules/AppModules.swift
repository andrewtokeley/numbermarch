//
//  AppModules.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 14/05/22.
//

import Foundation
import Viperit

//MARK: - Application modules
enum AppModules: String, ViperitModule {
    case loader
    case main
    case list
    var viewType: ViperitViewType {
        if self == .loader {
            return .storyboard
        } else {
            return .code
        }
    }
}
