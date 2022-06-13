//
//  AccountsRepositoryProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//
import Foundation

protocol AccountsRepositoryProtocol {
  func saveAccount(_ account: Account)
  func getAccounts() -> [Account]
  func deleteAccount(id: UUID)
  
  func addTransaction(_ transaction: Transaction, accountID: UUID)
  func getAccountTransactions(accountID: UUID) -> [Transaction]
}
