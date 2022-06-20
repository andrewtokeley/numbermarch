//
//  MainPresenter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//
//

import Foundation
import Viperit

// MARK: - MainPresenter Class
final class MainPresenter: Presenter {
    
    var calculator: CalculatorSkin?
    
//    override func setupView(data: Any) {
//        if let data = data as? MainDisplayData {
//            self.calculator = data.calculator
//        }
//    }
    
    override func viewHasLoaded() {
        if let data = view._displayData as? MainDisplayData {
            if let calculator = data.calculator {
                view.displayCalculator(calculator)
            }
        }
        
    }
    
}

// MARK: - MainPresenter API
extension MainPresenter: MainPresenterApi {
}

// MARK: - Main Viper Components
private extension MainPresenter {
    var view: MainViewApi {
        return _view as! MainViewApi
    }
    var interactor: MainInteractorApi {
        return _interactor as! MainInteractorApi
    }
    var router: MainRouterApi {
        return _router as! MainRouterApi
    }
}
