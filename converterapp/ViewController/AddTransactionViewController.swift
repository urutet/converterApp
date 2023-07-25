//
//  AddAccountViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit
import Combine
import EyeTracking

class AddTransactionViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AddTransactionViewModel!
  // MARK: Private
    private let manager = TrackingManager.shared
    private var lastActionDate = Date()
  private var subscriptions = [AnyCancellable]()
  
  private enum Constants {
    static let dateFormat = "dd.MM.yyyy"
    static let allowedCharacters = ".,0123456789"
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
    textField.keyboardType = .decimalPad
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
    amountTextField.delegate = self
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }
    
    override func viewDidAppear(_ animated: Bool) {
      setupEyeTracking()
      super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      removeEyeTracking()
    }
  
  // MARK: - API
  // MARK: - Setups
    private func setupEyeTracking() {
      manager.eyeTracker.setDelegate(self)
      manager.faceTracker.setDelegate(self)
      manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.3, maxValue: 1))
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.3, maxValue: 1))

    }
    
    private func removeEyeTracking() {
      manager.eyeTracker.removeDelegate(self)
      manager.faceTracker.removeDelegate(self)
      manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.3, maxValue: 1))
          manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.3, maxValue: 1))
    }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
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
    
  }
  
  private func addSubviews() {
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(nameTextField)
//    stackView.addArrangedSubview(dateTextField)
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
//      dateTextField.heightAnchor.constraint(equalToConstant: 40),
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
    
    viewModel.transactionName.sink { [weak self] name in
      self?.nameTextField.text = name
    }
    .store(in: &subscriptions)
    
    viewModel.transactionDate.sink { [weak self] date in
      guard let strongSelf = self else { return }
      strongSelf.dateTextField.text = strongSelf.dateFormatter.string(from: date ?? Date())
    }
    .store(in: &subscriptions)
    
    viewModel.transactionAmount.sink { [weak self] amount in
      guard let amount = amount else  { return }
      self?.amountTextField.text = String(describing: amount)
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
    viewModel.transactionDate.send(dateFormatter.date(from: dateTextField.text ?? ""))
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
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard textField.isEqual(amountTextField) else { return true }
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

extension AddTransactionViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
      guard Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 2.0 else { return }
    switch state {
    case .screenIn:
      guard let expression else { return }
      switch expression.blendShape {
      case .mouthSmileLeft:
          navigationController?.popViewController(animated: true)
      case .eyeBlinkLeft:
          saveTransaction()
      default:
        return
      }
    case .screenOut:
      return
      }
      lastActionDate = Date()

    }
  
  public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
    manager.eyeTracker.delegates.forEach { delegate in
      delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
    }
  }
}
