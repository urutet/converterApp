//
//  RatesViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import Combine

final class RatesViewController: UIViewController {

  // MARK: - Properties
  // MARK: Public
  var viewModel: RatesViewModel!
  // MARK: Private
  private enum Constants {
    static let rateCellIdentifier = "RateTableViewCell"
  }
  
  private let subscriptions = Set<AnyCancellable>()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(RateTableViewCell.self, forCellReuseIdentifier: Constants.rateCellIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    addConstraints()
    setupSubscriptions()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  // MARK: - API
  // MARK: - Setups
  private func setupSubscriptions() {
    viewModel.$currencyRates.sink { [weak self] _ in
      self?.tableView.reloadData()
    }
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  // MARK: - Helpers
}

extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.currencyRates.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.rateCellIdentifier) as? RateTableViewCell
    else { return UITableViewCell() }
    
    cell.setRate(currency: viewModel.currencyRates[indexPath.row])
    
    return cell
  }
  
  
}
