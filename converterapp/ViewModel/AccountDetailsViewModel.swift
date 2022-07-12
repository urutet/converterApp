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
      strongSelf.account.balance += transaction.amount
      strongSelf.accountsRepository.saveTransaction(transaction, accountID: strongSelf.account.id)
      strongSelf.account.transactions.sort { $0.date > $1.date }
      addTransactionViewModel.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func editTransaction(index: Int) {
    let addTransactionViewModel = coordinator.goToEditTransactionViewController(
      transaction: account.transactions[index]
    )
    addTransactionViewModel.saveAction.sink { [weak self] transaction in
      guard let strongSelf = self else { return }
      
      strongSelf.account.balance -= strongSelf.account.transactions[index].amount
      strongSelf.account.transactions.remove(at: index)
      
      strongSelf.account.balance += transaction.amount
      strongSelf.account.transactions.append(transaction)
      
      strongSelf.accountsRepository.saveTransaction(transaction, accountID: strongSelf.account.id)
      strongSelf.account.transactions.sort { $0.date > $1.date }
      addTransactionViewModel.coordinator.pop()
    }
    .store(in: &subscriptions)
  }
  
  func deleteTransaction(index: Int) {
    account.balance -= account.transactions[index].amount
    accountsRepository.deleteTransaction(id: account.transactions[index].id)
    account.transactions.remove(at: index)
  }
  
  func getTransactions() {
    account.transactions = accountsRepository.getAccountTransactions(accountID: account.id)
      .sorted { $0.date > $1.date }
  }
}
