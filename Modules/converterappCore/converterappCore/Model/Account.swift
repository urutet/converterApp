//
//  Account.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

public struct Account {
  public let id: UUID
  public let name: String
  public let currency: String
  public var balance: Decimal
  public var transactions = [Transaction]()
  
  public init(id: UUID = UUID(), name: String, currency: String, balance: Decimal, transactions: [Transaction]) {
    self.id = id
    self.name = name
    self.currency = currency
    self.balance = balance
    self.transactions = transactions
  }
}
