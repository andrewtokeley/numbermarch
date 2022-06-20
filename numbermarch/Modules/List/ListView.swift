//
//  ListView.swift
//  numbermarch
//
//  Created by Andrew Tokeley on 20/06/22.
//
//

import UIKit
import Viperit
import PureLayout

//MARK: ListView Class
final class ListView: UserInterface {
    
    var calculators = [CalculatorSkin]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .gameBackground
        self.view.addSubview(tableView)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
}

extension ListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calculators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let calculator = calculators[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.image = calculator.image
        content.imageProperties.maximumSize = CGSize(width: 100, height: 200)
        content.text = calculator.name
        content.secondaryText = calculator.description
        cell.contentConfiguration = content

        return cell
    }
}

extension ListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCalculator(calculators[indexPath.row])
    }
}

//MARK: - ListView API
extension ListView: ListViewApi {
    func displayCalculators(_ calculators: [CalculatorSkin]) {
        self.calculators = calculators
        self.tableView.reloadData()
        
    }
    
}

// MARK: - ListView Viper Components API
private extension ListView {
    var presenter: ListPresenterApi {
        return _presenter as! ListPresenterApi
    }
    var displayData: ListDisplayData {
        return _displayData as! ListDisplayData
    }
}
