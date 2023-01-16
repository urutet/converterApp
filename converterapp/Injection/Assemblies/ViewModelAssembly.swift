//
//  ViewModelAssembly.swift
//  converterapp
//
//  Created by user on 20.12.2022.
//

import Foundation
import Swinject

final class ViewModelAssembly: Assembly {
  
  func assemble(container: Swinject.Container) {
    container.register(AccountsViewModel.self) { resolver in
      let viewModel = AccountsViewModel()
      
      viewModel.accountsRepository = resolver.resolve(AccountsRepositoryProtocol.self)
      
      return viewModel
    }
    
    container.register(RatesViewModel.self) { resolver in
      let viewModel = RatesViewModel()
      
      viewModel.currenciesCache = resolver.resolve(CurrenciesCacheProtocol.self)
      viewModel.ratesRepository = resolver.resolve(RatesRepositoryProtocol.self)
      
      return viewModel
    }
    
    container.register(ConverterViewModel.self) { resolver in
      let viewModel = ConverterViewModel()
      
      viewModel.ratesRepository = resolver.resolve(RatesRepositoryProtocol.self)
      
      return viewModel
    }
    
    container.register(AuthViewModel.self) { resolver in
      let viewModel = AuthViewModel()
      
      viewModel.authService = resolver.resolve(EmailAuthServiceProtocol.self)
      
      return viewModel
    }
    
  }
  
}
