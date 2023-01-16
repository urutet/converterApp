//
//  AuthServiceProtocol.swift
//  converterapp
//
//  Created by user on 12.01.2023.
//

import Foundation

enum AuthState {
  case loggedIn
  case notLoggedIn
}

protocol EmailAuthServiceProtocol {
  func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
  func signup(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
  func logout()
}

protocol AuthStateListener {
  func addAuthStateListener(completion: @escaping (AuthState) -> Void)
}
