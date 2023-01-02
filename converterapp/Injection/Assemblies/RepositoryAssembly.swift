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
    
    container.register(CurrenciesCacheProtocol.self) { _ in CurrenciesCache() }
      .inObjectScope(.container)
    
    container.register(RatesRepositoryProtocol.self) { resolver in
      RatesURLSessionRepository(currenciesCache: resolver.resolve(CurrenciesCacheProtocol.self))
    }
    .inObjectScope(.container)
    
  }
  
}
