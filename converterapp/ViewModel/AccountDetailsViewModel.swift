//
//  AccountDetailsViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 11.05.22.
//
import Combine

final class AccountDetailsViewModel {
  var coordinator: AccountDetailsCoordinator!
  @Published var account: Account!
  var subscriptions = Set<AnyCancellable>()
  let accountsRepository: AccountsRepositoryProtocol = AccountsCoreDataRepository.shared

  func addTransaciton() {
    let addTransactionViewModel = coordinator.goToAddTransactionViewController()
    addTransactionViewModel.saveAction.sink { [weak self] transaction in
      guard let strongSelf = self else { return }
      strongSelf.account.transactions.append(transaction)
      strongSelf.accountsRepository.addTransaction(transaction, account: strongSelf.account)
      addTransactionViewModel.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func getTransactions() {
    account.transactions = accountsRepository.getAccountTransactions(account: account)
  }
}
