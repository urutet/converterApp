//
//  AuthViewController.swift
//  converterapp
//
//  Created by user on 11.01.2023.
//

import UIKit
import Combine
import EyeTracking

class AuthViewController: UIViewController {
  private enum Constants {
    static let animationDuration = 0.5
  }
  var viewModel: AuthViewModel!
  private var subscriptions = Set<AnyCancellable>()
  
  private let manager = TrackingManager.shared
  
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
  
  private let emailTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.keyboardType = .emailAddress
    textField.setTitle(Strings.Auth.email)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    textField.tag = 0
    
    return textField
  }()
  
  private let passwordTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isSecureTextEntry = true
    textField.setTitle(Strings.Auth.password)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    textField.tag = 1

    return textField
  }()
  
  private let confirmPasswordTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isSecureTextEntry = true
    textField.setTitle(Strings.Auth.confirmPassword)
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    textField.tag = 2
    
    return textField
  }()
  
  private let topButton: TitledButton = {
    let button = TitledButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Strings.Auth.confirmPassword, for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    
    return button
  }()
  
  private let bottomButton: TitledButton = {
    let button = TitledButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Strings.Auth.signUp, for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(changeLayout), for: .touchUpInside)
    
    return button
  }()
  
  private let authorizeWithFaceIDButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "faceid"), for: .normal)
    button.setTitle("Login with FaceID", for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(loginWithFaceID), for: .touchUpInside)
    
    return button
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.bold(ofSize: 15)
    label.textColor = .red
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = Strings.Auth.login
    
    addSubviews()
    addConstraints()
    setupSubscriptions()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeEyeTracking()
  }
  
  // MARK: - Setups
  private func setupEyeTracking() {
    manager.eyeTracker.setDelegate(self)
    manager.faceTracker.setDelegate(self)
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
  }
  
  private func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
  }
  
  private func addSubviews() {
//    view.addSubview(scrollView)
//    scrollView.addSubview(stackView)
//    stackView.addArrangedSubview(emailTextField)
//    stackView.addArrangedSubview(passwordTextField)
//    stackView.addArrangedSubview(confirmPasswordTextField)
//    stackView.addArrangedSubview(topButton)
//    stackView.addArrangedSubview(bottomButton)
//    stackView.addArrangedSubview(errorLabel)
    view.addSubview(authorizeWithFaceIDButton)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
//      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
//      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
//      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//      emailTextField.heightAnchor.constraint(equalToConstant: 40),
//      passwordTextField.heightAnchor.constraint(equalToConstant: 40),
//      confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
//      topButton.heightAnchor.constraint(equalToConstant: 40),
//      bottomButton.heightAnchor.constraint(equalToConstant: 40),
//      authorizeWithFaceIDButton.heightAnchor.constraint(equalToConstant: 40)
        
        authorizeWithFaceIDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        authorizeWithFaceIDButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func setupSubscriptions() {
    viewModel.isLoginScreen.sink { [weak self] isLoginScreen in
      guard let self else { return }
      isLoginScreen ? self.setLoginLayout() : self.setSignupLayout()
    }
    .store(in: &subscriptions)
    
    viewModel.errorPublisher.sink { [weak self] errorDescription in
      self?.errorLabel.text = errorDescription
    }
    .store(in: &subscriptions)
  }
  
  private func setLoginLayout() {
    navigationItem.title = Strings.Auth.login
    UIView.animate(withDuration: Constants.animationDuration, delay: 0) {
      self.confirmPasswordTextField.layer.opacity = 0
      self.confirmPasswordTextField.isHidden = true
      self.authorizeWithFaceIDButton.layer.opacity = 1
      self.authorizeWithFaceIDButton.isHidden = false
    }
    topButton.setText("")
    topButton.setTitle(Strings.Auth.login, for: .normal)
    topButton.removeTarget(self, action: #selector(signup), for: .touchUpInside)
    topButton.addTarget(self, action: #selector(login), for: .touchUpInside)

    bottomButton.setText(Strings.Auth.orYouCan)
    bottomButton.setTitle(Strings.Auth.signUp, for: .normal)
  }
  
  private func setSignupLayout() {
    navigationItem.title = Strings.Auth.signUp
    UIView.animate(withDuration: Constants.animationDuration, delay: 0) {
      self.confirmPasswordTextField.layer.opacity = 1
      self.confirmPasswordTextField.isHidden = false
      self.authorizeWithFaceIDButton.layer.opacity = 0
      self.authorizeWithFaceIDButton.isHidden = true
    }
    
    topButton.setText("")
    topButton.setTitle(Strings.Auth.signUp, for: .normal)
    topButton.removeTarget(self, action: #selector(login), for: .touchUpInside)
    topButton.addTarget(self, action: #selector(signup), for: .touchUpInside)

    bottomButton.setText(Strings.Auth.haveAnAccount)
    bottomButton.setTitle(Strings.Auth.login, for: .normal)
  }
  
  @objc
  private func login() {
    viewModel.email.send(emailTextField.text)
    viewModel.password.send(passwordTextField.text)
    viewModel.login()
  }
  
  @objc
  private func signup() {
    viewModel.email.send(emailTextField.text)
    viewModel.password.send(passwordTextField.text)
    viewModel.confirmPassword.send(confirmPasswordTextField.text)
    viewModel.signup()
  }
  
  @objc
  func changeLayout() {
    viewModel.isLoginScreen.send(!viewModel.isLoginScreen.value)
  }
  
  @objc
  func loginWithFaceID() {
    viewModel.loginWithFaceID()
  }
}

extension AuthViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
      switch expression.blendShape {
      case .jawOpen:
          authorizeWithFaceIDButton.sendActions(for: .touchUpInside)
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
