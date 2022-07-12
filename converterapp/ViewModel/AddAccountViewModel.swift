//
//  AddAccountViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import Combine
import Foundation

enum ControllerInputType {
  case add
  case edit
}

final class AddAccountViewModel {
  var coordinator: AddAccountCoordinator!
  var accountID: UUID!
  var controllerType: ControllerInputType!
  @Published var accountName: String? = nil
  @Published var accountCurrency: String? = nil
  let currencies = ["EUR", "USD", "BYN", "RUB"]
  let saveAction = PassthroughSubject<Account, Never>()
  
  func saveAccount() {
    guard
      let name = accountName,
      let currency = accountCurrency
    else { return }
    var account: Account
    switch controllerType {
    case .add:
      account = Account(name: name, currency: currency, balance: 0, transactions: [Transaction]())
    case .edit:
      account = Account(id: accountID, name: name, currency: currency, balance: 0, transactions: [Transaction]())
    case .none:
      return
    }
    saveAction.send(account)
  }
  
  func setAccount(account: Account) {
    accountID = account.id
    accountName = account.name
    accountCurrency = account.currency
  }
}
