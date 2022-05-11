//
//  AccountsViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation
import Combine

final class AccountsViewModel: ObservableObject {
  var coordinator: AccountsCoordinator!
  var subscriptions = Set<AnyCancellable>()
  @Published var accounts = [Account]()
  
  
  func addAccount() {
    let addAccountViewModel = coordinator.goToAddAccountViewController()
    addAccountViewModel.saveAction.sink { [weak self] account in
      guard let strongSelf = self else { return }
      strongSelf.accounts.append(account)
      strongSelf.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func showAccountDetails(index: Int) {
    let accountDetailsViewModel = coordinator.goToAccountDetailsViewController(index: index)
  }
}
