//
//  ListPresenter.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 20/06/22.
//
//

import Foundation
import Viperit

// MARK: - ListPresenter Class
final class ListPresenter: Presenter {
    
    override func viewIsAboutToAppear() {
        interactor.fetchCalculators()
    }
}

// MARK: - ListPresenter API
extension ListPresenter: ListPresenterApi {
    func didSelectCalculator(_ calculator: CalculatorSkin) {
        router.navigateToMain(calculator)
    }
    
    func didFetchCalculators(_ calculators: [CalculatorSkin]) {
        view.displayCalculators(calculators)
    }
    
}

// MARK: - List Viper Components
private extension ListPresenter {
    var view: ListViewApi {
        return _view as! ListViewApi
    }
    var interactor: ListInteractorApi {
        return _interactor as! ListInteractorApi
    }
    var router: ListRouterApi {
        return _router as! ListRouterApi
    }
}
