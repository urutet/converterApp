//
//  AddAccountViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import Combine

final class AddAccountViewModel {
  var accountName: String? = nil
  var accountCurrency: String? = nil
  let currencies = ["EUR", "USD", "BYN", "RUB"]
  let saveAction = PassthroughSubject<Account, Never>()
  
  func saveAccount() {
    guard
      let name = accountName,
      let currency = accountCurrency
    else { return }
    let account = Account(name: name, currency: currency, balance: nil, transactions: nil)
    saveAction.send(account)
  }
}
