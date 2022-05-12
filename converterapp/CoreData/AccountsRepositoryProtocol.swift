//
//  AccountsRepositoryProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

protocol AccountsRepositoryProtocol {
  func saveAccount(_ account: Account)
  func getAccounts() -> [Account]?
  func deleteAccount(name: String)
}
