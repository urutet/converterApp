//
//  AuthViewModel.swift
//  converterapp
//
//  Created by user on 11.01.2023.
//

import Foundation
import Combine

final class AuthViewModel {
  private enum Constants {
    static let emailRegex = try! NSRegularExpression(pattern:  #"^\S+@\S+\.\S+$"#, options: [])
  }
  
  var coordinator: AuthCoordinator!
  var email = CurrentValueSubject<String?, Never>(nil)
  var isEmailValid: AnyPublisher<Bool, Never> {
    email.map { email in
      guard let email else { return false }
      let result = Constants.emailRegex.matches(
        in: email,
        options: [],
        range: NSRange(email.startIndex..<email.endIndex, in: email)
      )
      return result != nil
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
      return password == self.confirmPassword.value
    }
    .replaceNil(with: false)
    .dropFirst()
    .eraseToAnyPublisher()
  }
  
  func login() {
    
  }
  
  func signup() {
    
  }
}

extension AuthViewModel {
  
}
