//
//  AccountsCoreDataRepository.swift
//  MovieSaver
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import UIKit
import CoreData

final class AccountsCoreDataRepository: AccountsRepositoryProtocol {
  private enum Constants {
    static let movieEntityName = "MovieMO"
    static let transactionEntityName = "TransactionMO"
    static let namePredicate = "name == %@"
    static let containerName = "Account"
  }
  
  static let shared = AccountsCoreDataRepository()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: Constants.containerName)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private init() { }
  
  private func convertToAccountMO(account: Account, context: NSManagedObjectContext) -> AccountMO {
    let accountMO = AccountMO(context: context)
    
    accountMO.name = account.name
    accountMO.currency = account.currency
    if
      let transactions = account.transactions,
      let balance = account.balance {
      accountMO.transactions = NSSet(array: transactions)
      accountMO.balance = NSDecimalNumber(decimal: balance)
    }
    
    return accountMO
  }
  
  private func convertToAccount(accountMO: AccountMO) -> Account? {
    guard
      let name = accountMO.name,
      let currency = accountMO.currency,
      let balance = accountMO.balance,
      let transactions = accountMO.transactions
    else { return nil }
    return Account(
      name: name,
      currency: currency,
      balance: balance as Decimal,
      transactions: transactions.allObjects as? [Transaction]
    )
  }
  
  func saveAccount(_ account: Account) {
    let managedContext = persistentContainer.viewContext
    
    let managedMovie = convertToAccountMO(account: account, context: managedContext)
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Error - \(error)")
    }
  }
  
  func getAccounts() -> [Account]? {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = AccountMO.fetchRequest()
    
    do {
      let accountMO = try managedContext.fetch(fetchRequest)
      let accounts = accountMO.compactMap{ convertToAccount(accountMO: $0) }
      return accounts
    } catch let error as NSError {
      print("Error - \(error)")
    }
    return nil
  }
  
  func deleteAccount(name: String) {
    let managedContext = persistentContainer.viewContext
    
    let fetchRequest = AccountMO.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: Constants.namePredicate, name)
    
    do {
      let objects = try managedContext.fetch(fetchRequest)
      for object in objects {
        managedContext.delete(object)
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Error - \(error)")
    }
  }
}
