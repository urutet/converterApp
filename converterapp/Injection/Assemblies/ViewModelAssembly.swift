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
  }
  
}
