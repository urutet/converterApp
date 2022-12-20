//
//  RepositoryAssembly.swift
//  converterapp
//
//  Created by user on 20.12.2022.
//

import Foundation
import Swinject

final class RepositoryAssembly: Assembly {
  
  func assemble(container: Swinject.Container) {
    container.register(AccountsRepositoryProtocol.self) { _ in AccountsCoreDataRepository() }
      .inObjectScope(.container)
  }
  
}
