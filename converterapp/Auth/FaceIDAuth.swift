//
//  FaceIDAuth.swift
//  converterapp
//
//  Created by user on 16.01.2023.
//

import LocalAuthentication

final class FaceIDAuth {
  func authorizeWithBiometrics(completion: @escaping (Result<Bool, Error>) -> Void) {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      error: &error
    ) {
      let reason = "Authorize with FaceID"
      
      context.evaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        localizedReason: reason) { success, error in
          DispatchQueue.main.async {
            guard success, error == nil else { return completion(.failure(error!)) }
            return completion(.success(success))
          }
        }
    }
  }
}
