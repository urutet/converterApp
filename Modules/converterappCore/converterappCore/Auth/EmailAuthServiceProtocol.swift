//
//  AuthServiceProtocol.swift
//  converterapp
//
//  Created by user on 12.01.2023.
//

import Foundation

public enum AuthState {
  case loggedIn
  case notLoggedIn
}

public protocol EmailAuthServiceProtocol {
  func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
  func signup(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
  func logout()
}

public protocol AuthStateListener {
  func addAuthStateListener(completion: @escaping (AuthState) -> Void)
}
