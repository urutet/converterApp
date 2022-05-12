//
//  ConverterViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import Combine

final class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: ConverterViewModel!
  // MARK: Private
  private enum Constants {
    static let ConverterTableViewCellIdentifier = "ConverterTableViewCell"
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ConverterTableViewCell.self, forCellReuseIdentifier: Constants.ConverterTableViewCellIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Strings.Rates.title
    addSubviews()
    addConstraints()
    setupSubscriptions()
    viewModel.getRates()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - API
  // MARK: - Setups
  private func setupSubscriptions() {
    viewModel.$currencies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
      }
      .store(in: &subscriptions)
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
}

extension ConverterViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.currencies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.ConverterTableViewCellIdentifier) as? ConverterTableViewCell
    else { return UITableViewCell() }
    
    cell.setRate(currency: viewModel.currencies[indexPath.row])
    cell.currencyAmountTextField.delegate = self
    
    return cell
  }
}
