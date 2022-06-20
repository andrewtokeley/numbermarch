//
//  MainModuleApi.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//
//

import Viperit

//MARK: - MainRouter API
protocol MainRouterApi: RouterProtocol {
}

//MARK: - MainView API
protocol MainViewApi: UserInterfaceProtocol {
    func displayCalculator(_ calculator: CalculatorSkin)
}

//MARK: - MainPresenter API
protocol MainPresenterApi: PresenterProtocol {
}

//MARK: - MainInteractor API
protocol MainInteractorApi: InteractorProtocol {
}
