//
//  AddAccountViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit
import Combine

class AddTransactionViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AddTransactionViewModel!
  // MARK: Private
  private var subscriptions = [AnyCancellable]()
  
  private enum Constants {
    static let dateFormat = "dd.MM.yyyy"
  }
  
  private enum DataType: String {
    case name
    case amount
  }
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.bounces = false
    
    return scrollView
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.spacing = 30
    
    return stackView
  }()
  
  private let nameTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setTitle(Strings.AddTransaction.name)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker(
      frame: CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.width,
        height: 200
      )
    )
    
    if #available(iOS 13.4, *) {
       datePicker.preferredDatePickerStyle = .wheels
    }
    datePicker.datePickerMode = .date
    
    return datePicker
  }()
  
  private let dateTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setTitle(Strings.AddTransaction.date)
    
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let amountTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setTitle(Strings.AddTransaction.amount)
    
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Strings.AddAccounts.save, for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(saveTransaction), for: .touchUpInside)
    
    return button
  }()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addSubviews()
    addConstraints()
    setupSubscriptions()
    
    nameTextField.delegate = self
    dateTextField.delegate = self
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }
  
  // MARK: - Setups
  private func setupUI() {
    dateTextField.inputView = datePicker
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    let doneButton = UIBarButtonItem(
      title: Strings.AddAccounts.done,
      style: .plain,
      target: self,
      action: #selector(doneTapped)
    )
    let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.setItems([spacing, doneButton], animated: true)
    dateTextField.inputAccessoryView = toolbar
    
    dateTextField.text = dateFormatter.string(from: viewModel.transactionDate ?? Date())
  }
  
  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(nameTextField)
    stackView.addArrangedSubview(dateTextField)
    stackView.addArrangedSubview(amountTextField)
    stackView.addArrangedSubview(saveButton)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      nameTextField.heightAnchor.constraint(equalToConstant: 40),
      dateTextField.heightAnchor.constraint(equalToConstant: 40),
      amountTextField.heightAnchor.constraint(equalToConstant: 40),
      saveButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func setupSubscriptions() {
    viewModel.isTransactionAmountValidPublisher.sink { [weak self] isValid in
      guard !isValid else { return }
      self?.showInvalidDataAlert(dataType: .amount)
    }
    .store(in: &subscriptions)
    
    viewModel.isNameValidPublisher.sink { [weak self] isValid in
      guard !isValid else { return }
      self?.showInvalidDataAlert(dataType: .name)
    }
    .store(in: &subscriptions)
  }
  // MARK: - Helpers
  @objc
  private func doneTapped() {
    dateTextField.resignFirstResponder()
  }
  
  @objc
  private func dateChanged() {
    dateTextField.text = dateFormatter.string(from: datePicker.date)
  }
  
  @objc
  private func saveTransaction() {
    viewModel.transactionName.send(nameTextField.text)
    viewModel.transactionDate = dateFormatter.date(from: dateTextField.text ?? "")
    viewModel.transactionAmount.send(Decimal(string: amountTextField.text ?? ""))
    viewModel.saveTransaction()
  }
  
  private func showInvalidDataAlert(dataType: DataType) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    switch dataType {
    case .name:
      alert.title = Strings.AddTransaction.invalidName
    case .amount:
      alert.title = Strings.AddTransaction.invalidAmount
    }
    alert.addAction(UIAlertAction(title: Strings.AddTransaction.dismiss, style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

extension AddTransactionViewController: UITextFieldDelegate, UIPickerViewDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}
