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
    self.accounts = accountsRepository.getAccounts()
  }
  
  func deleteAccount(index: Int) {
    accountsRepository.deleteAccount(accounts[index])
    accounts.remove(at: index)
  }
  
  func showAccountDetails(index: Int) {
    let viewModel = coordinator.goToAccountDetailsViewController(index: index)
    viewModel.$account.sink { [weak self] account in
      guard let account = account else { return }
      self?.accounts[index] = account
    }
    .store(in: &subscriptions)
  }
}
