//
//  AccountsRepositoryProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

protocol AccountsRepositoryProtocol {
  func saveAccount(_ account: Account)
  func getAccounts() -> [Account]?
  func deleteAccount(_ account: Account)
  
  func addTransaction(_ transaction: Transaction, account: Account)
  func getAccountTransactions(account: Account) -> [Transaction]?
}
