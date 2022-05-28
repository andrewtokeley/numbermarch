//
//  CalculatorRouter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//
//

import Foundation
import Viperit

// MARK: - CalculatorRouter class
final class CalculatorRouter: Router {
}

// MARK: - CalculatorRouter API
extension CalculatorRouter: CalculatorRouterApi {
}

// MARK: - Calculator Viper Components
private extension CalculatorRouter {
    var presenter: CalculatorPresenterApi {
        return _presenter as! CalculatorPresenterApi
    }
}
