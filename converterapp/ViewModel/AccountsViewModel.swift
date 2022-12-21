//
//  AccountsViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation
import Combine

final class AccountsViewModel: AppDependencyProvider, ObservableObject {
  var coordinator: AccountsCoordinator!
  var subscriptions = Set<AnyCancellable>()
  var accountsRepository: AccountsRepositoryProtocol? = container.resolve(AccountsRepositoryProtocol.self)
  let remoteConfig: RemoteConfigProtocol = FirebaseRemoteConfig.shared
  @Published var accounts = [Account]()
  
  
  func addAccount() {
    let addAccountViewModel = coordinator.goToAddAccountViewController()
    addAccountViewModel.saveAction.sink { [weak self] account in
      guard let strongSelf = self else { return }
      strongSelf.accounts.append(account)
      strongSelf.accountsRepository?.saveAccount(account)
      strongSelf.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func getAccounts() {
    guard let accountsRepository else { return }
    self.accounts = accountsRepository.getAccounts()
  }
  
  func deleteAccount(index: Int) {
    accountsRepository?.deleteAccount(id: accounts[index].id)
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
  
  func editAccount(index: Int) {
    let addAccountViewModel = coordinator.goToEditAccountViewController(account: accounts[index])
    addAccountViewModel.saveAction.sink { [weak self] account in
      guard let strongSelf = self else { return }
      strongSelf.accounts.remove(at: index)
      strongSelf.accounts.insert(account, at: index)
      strongSelf.accountsRepository?.saveAccount(account)
      strongSelf.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
}
