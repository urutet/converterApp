//
//  AddAccountViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit
import Combine
import EyeTracking

class AddAccountViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AddAccountViewModel!
  // MARK: Private
    private let manager = TrackingManager.shared
    private var lastActionDate = Date()
    private let recognizer = SpeechRecognizer()
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
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.7, maxValue: 1))
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkRight, minValue: 0.7, maxValue: 1))

    }
    
    private func removeEyeTracking() {
      manager.eyeTracker.removeDelegate(self)
      manager.faceTracker.removeDelegate(self)
      manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.3, maxValue: 1))
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.3, maxValue: 1))
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkRight, minValue: 0.7, maxValue: 1))
    }
    
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
    
    if viewModel.controllerType == .edit {
      currencyTextField.textColor = .systemGray3
      currencyTextField.isEnabled = false
    }
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

extension AddAccountViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
        guard Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 2.0 else { return }
        lastActionDate = Date()
      switch expression.blendShape {
      case .mouthSmileLeft:
          navigationController?.popViewController(animated: true)
      case .eyeBlinkLeft:
          saveAccount()
      case .jawOpen:
          recognizer.startTranscribing()
      case .eyeBlinkRight:
          nameTextField.text = recognizer.transcript
          recognizer.stopTranscribing()
          recognizer.transcript = ""
      default:
        return
      }
    case .screenOut:
      return
      }
    }
  
  public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
    manager.eyeTracker.delegates.forEach { delegate in
      delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
    }
  }
}
