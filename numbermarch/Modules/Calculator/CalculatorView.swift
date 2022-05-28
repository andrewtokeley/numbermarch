//
//  CalculatorView.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 28/05/22.
//
//

import UIKit
import Viperit

//MARK: CalculatorView Class
final class CalculatorView: UserInterface {
}

//MARK: - CalculatorView API
extension CalculatorView: CalculatorViewApi {
}

// MARK: - CalculatorView Viper Components API
private extension CalculatorView {
    var presenter: CalculatorPresenterApi {
        return _presenter as! CalculatorPresenterApi
    }
    var displayData: CalculatorDisplayData {
        return _displayData as! CalculatorDisplayData
    }
}
