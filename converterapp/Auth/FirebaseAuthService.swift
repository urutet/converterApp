//
//  FirebaseAuthService.swift
//  converterapp
//
//  Created by user on 12.01.2023.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService: EmailAuthServiceProtocol, AuthStateListener {
  private let firebaseAuth = Auth.auth()
  private var authStateListener: AuthStateDidChangeListenerHandle?
  
  func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    firebaseAuth.signIn(withEmail: email, password: password) { authResult, error in
      if let error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }
  
  func signup(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
      if let error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }
  
  func logout() {
    do {
      try firebaseAuth.signOut()
    } catch let signOutError {
      print("Error signing out: \(signOutError.localizedDescription)")
    }
  }
  
  func addAuthStateListener(completion: @escaping (AuthState) -> Void) {
    authStateListener = Auth.auth().addStateDidChangeListener({ auth, user in
      user != nil ? completion(.loggedIn) : completion(.notLoggedIn)
    })
  }
}
