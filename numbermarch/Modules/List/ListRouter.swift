//
//  ListRouter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 20/06/22.
//
//

import Foundation
import Viperit

// MARK: - ListRouter class
final class ListRouter: Router {
    
    func navigateToMain(_ calculator: CalculatorSkin) {
        let module = AppModules.main.build()
        (module.displayData as? MainDisplayData)?.calculator = calculator
        module.router.show(from: viewController, embedInNavController: false, setupData: nil)
    }
    
}

// MARK: - ListRouter API
extension ListRouter: ListRouterApi {
}

// MARK: - List Viper Components
private extension ListRouter {
    var presenter: ListPresenterApi {
        return _presenter as! ListPresenterApi
    }
}
