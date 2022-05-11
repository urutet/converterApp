//
//  AccountDetailsViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 11.05.22.
//

import UIKit

final class AccountDetailsViewController: UIViewController {

  // MARK: - Properties
  // MARK: Public
  var viewModel: AccountDetailsViewModel!
  // MARK: Private
  private enum Constants {
    static let cellHeight: CGFloat = 100
    static let TransactionCellReuseIdentifier = "TransactionCell"
  }
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: Constants.TransactionCellReuseIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.account.name
    addSubviews()
    addConstraints()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - API
  // MARK: - Setups
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

extension AccountDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.account.transactions?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.TransactionCellReuseIdentifier) as? TransactionTableViewCell
    else  { return UITableViewCell() }
    
    cell.setTransaction(account: viewModel.account, index: indexPath.row)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    Constants.cellHeight
  }
}
