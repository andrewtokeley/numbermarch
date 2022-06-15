//
//  MainInteractor.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 13/06/22.
//
//

import Foundation
import Viperit

// MARK: - MainInteractor Class
final class MainInteractor: Interactor {
}

// MARK: - MainInteractor API
extension MainInteractor: MainInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MainInteractor {
    var presenter: MainPresenterApi {
        return _presenter as! MainPresenterApi
    }
}
