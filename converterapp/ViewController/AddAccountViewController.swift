//
//  AddAccountViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit
import Combine

class AddAccountViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AddAccountViewModel!
  // MARK: Private
  private var subscriptions = Set<AnyCancellable>()
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
    textField.setTitle(Strings.AddAccounts.accountName)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let currencyPickerView = UIPickerView(
    frame: CGRect(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: 200
    )
  )
  
  private let currencyTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setTitle(Strings.AddAccounts.accountCurrency)
    
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
    button.addTarget(self, action: #selector(saveAccount), for: .touchUpInside)
    
    return button
  }()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupSubscriptions()
    addSubviews()
    addConstraints()
    
    nameTextField.delegate = self
    currencyPickerView.delegate = self
  }
  
  // MARK: - API
  // MARK: - Setups
  private func setupUI() {
    view.backgroundColor = .systemBackground
    currencyTextField.inputView = currencyPickerView
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    let doneButton = UIBarButtonItem(
      title: Strings.AddAccounts.done,
      style: .plain,
      target: self,
      action: #selector(doneTapped)
    )
    let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.setItems([spacing, doneButton], animated: true)
    currencyTextField.inputAccessoryView = toolbar
  }
  
  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(nameTextField)
    stackView.addArrangedSubview(currencyTextField)
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
      currencyTextField.heightAnchor.constraint(equalToConstant: 40),
      saveButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func setupSubscriptions() {
    viewModel.$accountName
      .receive(on: DispatchQueue.main)
      .sink { [weak self] name in
        self?.nameTextField.text = name
      }
      .store(in: &subscriptions)
    
    viewModel.$accountCurrency
      .receive(on: DispatchQueue.main)
      .sink { [weak self] currency in
        self?.currencyTextField.text = currency
      }
      .store(in: &subscriptions)
  }
  // MARK: - Helpers
  @objc
  private func doneTapped() {
    currencyTextField.resignFirstResponder()
  }
  
  @objc func saveAccount() {
    viewModel.accountName = nameTextField.text
    viewModel.accountCurrency = currencyTextField.text
    viewModel.saveAccount()
  }
}

extension AddAccountViewController: UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    viewModel.currencies.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    viewModel.currencies[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currencyTextField.text = viewModel.currencies[row]
  }
}
