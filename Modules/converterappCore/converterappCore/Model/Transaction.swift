//
//  Transaction.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

public struct Transaction {
  public let id: UUID
  public let name: String
  public let date: Date
  public let amount: Decimal
  
  public init(id: UUID = UUID(), name: String, date: Date, amount: Decimal) {
    self.id = id
    self.name = name
    self.date = date
    self.amount = amount
  }
}
