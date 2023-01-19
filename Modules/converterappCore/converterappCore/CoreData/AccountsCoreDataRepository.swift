//
//  AccountsCoreDataRepository.swift
//  MovieSaver
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import UIKit
import CoreData

public final class AccountsCoreDataRepository: AccountsRepositoryProtocol {
  private enum Constants {
    static let idPredicate = "id == %@"
    static let accountMOEntityName = "AccountMO"
    static let transactionMOEntityName = "TransactionMO"
  }
    
  let persistentContainer = PersistentContainerRepository.shared.persistentContainer
    
  @discardableResult
  private func convertToAccountMO(account: Account, context: NSManagedObjectContext) -> AccountMO {
    let accountMO = AccountMO(context: context)
    
    accountMO.id = account.id
    accountMO.name = account.name
    accountMO.currency = account.currency
    accountMO.balance = NSDecimalNumber(decimal: account.balance)

    return accountMO
  }
  
  private func editAccountMO(accountMO: AccountMO, account: Account) {
    accountMO.name = account.name
    accountMO.currency = account.currency
    accountMO.balance = NSDecimalNumber(decimal: account.balance)
  }
  
  private func convertToAccount(accountMO: AccountMO) -> Account? {
    guard
      let id = accountMO.id,
      let name = accountMO.name,
      let currency = accountMO.currency,
      let balance = accountMO.balance,
      let transactions = accountMO.transactions
    else { return nil }
    return Account(
      id: id,
      name: name,
      currency: currency,
      balance: balance as Decimal,
      transactions: transactions.allObjects as? [Transaction] ?? [Transaction]()
    )
  }
  
  @discardableResult
  private func convertToTransacitonMO(transaction: Transaction, context: NSManagedObjectContext) -> TransactionMO {
    let transactionMO = TransactionMO(context: context)
    
    transactionMO.id = transaction.id
    transactionMO.name = transaction.name
    transactionMO.date = transaction.date
    transactionMO.amount = NSDecimalNumber(decimal: transaction.amount)
    
    return transactionMO
  }
  
  private func editTransactionMO(transactionMO: TransactionMO, transaction: Transaction) {
    transactionMO.name = transaction.name
    transactionMO.date = transaction.date
    transactionMO.amount = NSDecimalNumber(decimal: transaction.amount)
  }
  
  private func convertToTransaction(transactionMO: TransactionMO) -> Transaction? {
    guard
      let id = transactionMO.id,
      let name = transactionMO.name,
      let date = transactionMO.date,
      let amount = transactionMO.amount as Decimal?
    else { return nil }
    
    return Transaction(id: id, name: name, date: date, amount: amount)
  }
  
  public func saveAccount(_ account: Account) {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = AccountMO.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: Constants.idPredicate, account.id.uuidString)
    
    do {
      let accountsMO = try managedContext.fetch(fetchRequest)
      
      // Check whether account exists
      if !accountsMO.contains(where: { $0.id == account.id }) {
        // Save new account
        convertToAccountMO(account: account, context: managedContext)
        try managedContext.save()
      } else {
        // Save account after editing
        guard let accountMO = accountsMO.first else { return }
        editAccountMO(accountMO: accountMO, account: account)
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Error - \(error)")
    }
  }
  
  public func getAccounts() -> [Account] {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = AccountMO.fetchRequest()
    
    do {
      let accountsMO = try managedContext.fetch(fetchRequest)
      let accounts = accountsMO.compactMap{ convertToAccount(accountMO: $0) }
      return accounts
    } catch let error as NSError {
      print("Error - \(error)")
    }
    return [Account]()
  }
  
  public func deleteAccount(id: UUID) {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.accountMOEntityName)
    fetchRequest.predicate = NSPredicate(format: Constants.idPredicate, id.uuidString)
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try managedContext.execute(deleteRequest)
      try managedContext.save()
    } catch let error as NSError {
      print("Error - \(error)")
    }
  }
  
  public func saveTransaction(_ transaction: Transaction, accountID: UUID) {
    let managedContext = persistentContainer.viewContext
    
    let accountFetchRequest = AccountMO.fetchRequest()
    accountFetchRequest.predicate = NSPredicate(format: Constants.idPredicate, accountID.uuidString)
        
    do {
      let accountsMO = try managedContext.fetch(accountFetchRequest)
      guard let transactions = accountsMO.first?.transactions?.allObjects as? [TransactionMO] else { return }
      
      if !transactions.contains(where: { $0.id == transaction.id }) {
        let transactionMO = convertToTransacitonMO(transaction: transaction, context: managedContext)
        accountsMO.first?.addToTransactions(transactionMO)
        try managedContext.save()
      } else {
        guard let transactionMO = transactions.filter({ $0.id == transaction.id }).first else { return }
        editTransactionMO(transactionMO: transactionMO, transaction: transaction)
        try managedContext.save()
      }
    } catch let error as NSError {
      print(error)
    }
  }
  
  public func getAccountTransactions(accountID: UUID) -> [Transaction] {
    let managedContext = persistentContainer.viewContext
    
    let accountFetchRequest = AccountMO.fetchRequest()
    accountFetchRequest.predicate = NSPredicate(format: Constants.idPredicate, accountID.uuidString)
    
    do {
      let accountsMO = try managedContext.fetch(accountFetchRequest)
      guard let transactionsMO = accountsMO.first?.transactions else { return [Transaction]() }
      let transactions = transactionsMO.compactMap { convertToTransaction(transactionMO: $0 as! TransactionMO) }
      
      return transactions
    } catch let error as NSError {
      print("Error - \(error)")
    }
    
    return [Transaction]()
  }
  
  public func deleteTransaction(id: UUID) {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.transactionMOEntityName)
    fetchRequest.predicate = NSPredicate(format: Constants.idPredicate, id.uuidString)
    
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try managedContext.execute(deleteRequest)
      try managedContext.save()
    } catch let error as NSError {
      print("Error - \(error)")
    }
  }
}
