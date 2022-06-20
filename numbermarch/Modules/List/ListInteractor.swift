//
//  ListInteractor.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 20/06/22.
//
//

import Foundation
import Viperit

// MARK: - ListInteractor Class
final class ListInteractor: Interactor {
}

// MARK: - ListInteractor API
extension ListInteractor: ListInteractorApi {
    func fetchCalculators() {
        let result: [CalculatorSkin] =  [
            MG880Skin(),
            MG775Skin(),
            MG885Skin()
        ]
        self.presenter.didFetchCalculators(result)
    }
}

// MARK: - Interactor Viper Components Api
private extension ListInteractor {
    var presenter: ListPresenterApi {
        return _presenter as! ListPresenterApi
    }
}
