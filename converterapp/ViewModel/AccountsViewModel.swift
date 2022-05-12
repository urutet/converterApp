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
  let accountsRepository: AccountsRepositoryProtocol = AccountsCoreDataRepository.shared
  @Published var accounts = [Account]()
  
  
  func addAccount() {
    let addAccountViewModel = coordinator.goToAddAccountViewController()
    addAccountViewModel.saveAction.sink { [weak self] account in
      guard let strongSelf = self else { return }
      strongSelf.accounts.append(account)
      strongSelf.accountsRepository.saveAccount(account)
      strongSelf.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func getAccounts() {
    if let accounts = accountsRepository.getAccounts() {
      self.accounts = accounts
    }
  }
  
  func deleteAccount(index: Int) {
    accountsRepository.deleteAccount(name: accounts[index].name)
    accounts.remove(at: index)
  }
  
  func showAccountDetails(index: Int) {
    let accountDetailsViewModel = coordinator.goToAccountDetailsViewController(index: index)
  }
}
