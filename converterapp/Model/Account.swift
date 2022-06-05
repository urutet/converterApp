//
//  Account.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

struct Account {
  let id: UUID
  let name: String
  let currency: String
  let balance: Decimal?
  var transactions = [Transaction]()
  
  init(name: String, currency: String, balance: Decimal?, transactions: [Transaction]) {
    self.id = UUID()
    self.name = name
    self.currency = currency
    self.balance = balance
    self.transactions = transactions
  }
  
  init(id: UUID, name: String, currency: String, balance: Decimal?, transactions: [Transaction]) {
    self.id = id
    self.name = name
    self.currency = currency
    self.balance = balance
    self.transactions = transactions
  }
}
