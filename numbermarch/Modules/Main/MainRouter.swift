//
//  MainRouter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//
//

import Foundation
import Viperit

// MARK: - MainRouter class
final class MainRouter: Router {
}

// MARK: - MainRouter API
extension MainRouter: MainRouterApi {
}

// MARK: - Main Viper Components
private extension MainRouter {
    var presenter: MainPresenterApi {
        return _presenter as! MainPresenterApi
    }
}
