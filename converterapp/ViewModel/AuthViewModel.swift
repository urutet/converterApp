//
//  AuthViewModel.swift
//  converterapp
//
//  Created by user on 11.01.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class AuthViewModel: AppDependencyProvider {
  private enum Constants {
    static let emailRegex = #"^\S+@\S+\.\S+$"#
  }
  
  var coordinator: AuthCoordinator!
  var authService: EmailAuthServiceProtocol? = container.resolve(EmailAuthServiceProtocol.self)
  
  var email = CurrentValueSubject<String?, Never>(nil)
  var isEmailValid: AnyPublisher<Bool, Never> {
    email.map { email in
      guard let email else { return false }
      return email.range(of: Constants.emailRegex, options: .regularExpression) != nil
    }
    .replaceNil(with: false)
    .dropFirst()
    .eraseToAnyPublisher()
  }
  
  var password = CurrentValueSubject<String?, Never>(nil)
  var confirmPassword = CurrentValueSubject<String?, Never>(nil)
  var passwordMatches: AnyPublisher<Bool, Never> {
    password.map { [weak self] password in
      guard let self else { return false }
      guard self.isLoginScreen.value else { return true }
      return password == self.confirmPassword.value
    }
    .replaceNil(with: false)
    .dropFirst()
    .eraseToAnyPublisher()
  }
  
  var errorPublisher = PassthroughSubject<String, Never>()
  
  var isLoginScreen = CurrentValueSubject<Bool, Never>(true)
  
  func login() {
    guard
      let email = email.value,
      let password = password.value
    else { return }
    authService?.login(email: email, password: password) { [weak self] result in
      switch result {
      case .success():
        print(Strings.Auth.loggedIn)
      case .failure(let error):
        self?.errorPublisher.send(error.localizedDescription)
      }
    }
  }
  
  func signup() {
    guard
      let email = email.value,
      let password = password.value
    else { return }
    authService?.signup(email: email, password: password) { [weak self] result in
      switch result {
      case .success():
        print(Strings.Auth.signedUp)
      case .failure(let error):
        self?.errorPublisher.send(error.localizedDescription)
      }
    }
  }
}
