//
//  AuthViewController.swift
//  converterapp
//
//  Created by user on 11.01.2023.
//

import UIKit

class AuthViewController: UIViewController {
  
  var viewModel: AuthViewModel!
  
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
    textField.setTitle("Email")
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let passwordTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isSecureTextEntry = true
    textField.setTitle("Password")
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let confirmPasswordTextField: TitledTextField = {
    let textField = TitledTextField()
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isSecureTextEntry = true
    textField.setTitle("Confirm Password")
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.systemGray4.cgColor
    textField.layer.cornerRadius = 5
    textField.font = FontsManager.medium(ofSize: 16)
    
    return textField
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Login", for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    
    return button
  }()
  
  private let signUpButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("SignUp", for: .normal)
    button.titleLabel?.font = FontsManager.bold(ofSize: 20)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    navigationItem.title = "Login"
    
    addSubviews()
    addConstraints()
  }
  
  private func addSubviews() {
//    view.addSubview(loginLabel)
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(emailTextField)
    stackView.addArrangedSubview(passwordTextField)
    stackView.addArrangedSubview(confirmPasswordTextField)
    stackView.addArrangedSubview(loginButton)
    stackView.addArrangedSubview(signUpButton)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      emailTextField.heightAnchor.constraint(equalToConstant: 40),
      passwordTextField.heightAnchor.constraint(equalToConstant: 40),
      confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
      loginButton.heightAnchor.constraint(equalToConstant: 40),
      signUpButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}
