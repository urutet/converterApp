//
//  AddAccountViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import Combine
import Foundation

final class AddAccountViewModel {
  var coordinator: AddAccountCoordinator!
  var accountName: String? = nil
  var accountCurrency: String? = nil
  let currencies = ["EUR", "USD", "BYN", "RUB"]
  let saveAction = PassthroughSubject<Account, Never>()
  
  func saveAccount() {
    guard
      let name = accountName,
      let currency = accountCurrency
    else { return }
    let account = Account(name: name, currency: currency, balance: nil, transactions: [Transaction(name: "qwe", date: Date(), amount: 100)])
    saveAction.send(account)
  }
}
