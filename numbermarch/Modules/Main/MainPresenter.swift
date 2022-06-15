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
