//
//  CalculatorInteractor.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//
//

import Foundation


// MARK: - CalculatorInteractor Class
final class CalculatorInteractor: Interactor {
}

// MARK: - CalculatorInteractor API
extension CalculatorInteractor: CalculatorInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension CalculatorInteractor {
    var presenter: CalculatorPresenterApi {
        return _presenter as! CalculatorPresenterApi
    }
}
