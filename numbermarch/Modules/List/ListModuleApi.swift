//
//  ListModuleApi.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 20/06/22.
//
//

import Viperit

//MARK: - ListRouter API
protocol ListRouterApi: RouterProtocol {
    func navigateToMain(_ calculator: CalculatorSkin)
}

//MARK: - ListView API
protocol ListViewApi: UserInterfaceProtocol {
    func displayCalculators(_ calculators: [CalculatorSkin])
}

//MARK: - ListPresenter API
protocol ListPresenterApi: PresenterProtocol {
    func didSelectCalculator(_ calculator: CalculatorSkin)
    func didFetchCalculators(_ calculators: [CalculatorSkin])
}

//MARK: - ListInteractor API
protocol ListInteractorApi: InteractorProtocol {
    func fetchCalculators()
}
