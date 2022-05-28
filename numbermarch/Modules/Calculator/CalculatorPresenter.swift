//
//  CalculatorPresenter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//
//

import Foundation

// MARK: - CalculatorPresenter Class
final class CalculatorPresenter: Presenter {
}

// MARK: - CalculatorPresenter API
extension CalculatorPresenter: CalculatorPresenterApi {
}

// MARK: - Calculator Viper Components
private extension CalculatorPresenter {
    var view: CalculatorViewApi {
        return _view as! CalculatorViewApi
    }
    var interactor: CalculatorInteractorApi {
        return _interactor as! CalculatorInteractorApi
    }
    var router: CalculatorRouterApi {
        return _router as! CalculatorRouterApi
    }
}
