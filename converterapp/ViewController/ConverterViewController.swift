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
    static let allowedCharacters = ".0123456789"
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
    setupUI()
    addSubviews()
    addConstraints()
    setupSubscriptions()
    viewModel.getRates()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: - API
  // MARK: - Setups
  private func setupUI() {
    title = Strings.Converter.title
    view.backgroundColor = .systemBackground
  }
  
  private func setupSubscriptions() {
    viewModel.$converterCellViewModels
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
    viewModel.converterCellViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
        .dequeueReusableCell(withIdentifier: Constants.ConverterTableViewCellIdentifier) as? ConverterTableViewCell
    else { return UITableViewCell() }
    
    cell.viewModel = viewModel.converterCellViewModels[indexPath.row]
    cell.currencyAmountTextField.delegate = self
    
    cell.selectionStyle = .none
    
    return cell
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let amount = Decimal(string: textField.text ?? "") else { return }
    let selectedCurrency = viewModel.converterCellViewModels
      .filter { $0.isSelected == true }
      .first?
      .currency
    
    let _ = viewModel.converterCellViewModels
      .filter { $0.isSelected == false }
      .map {
        $0.selectedCurrency = selectedCurrency
        $0.convertCurrency(amount: amount)
      }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    let _ = viewModel.converterCellViewModels.map { $0.isSelected = false }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if
      let textFieldIsEmpty = textField.text?.isEmpty,
      textFieldIsEmpty,
      string == "." || string == "," {
      return false
    }
    
    let allowedCharacters = CharacterSet(charactersIn: Constants.allowedCharacters)
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
}
