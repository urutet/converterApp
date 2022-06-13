//
//  Transaction.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

struct Transaction {
  let id: UUID
  let name: String
  let date: Date
  let amount: Decimal
  
  init(id: UUID = UUID(), name: String, date: Date, amount: Decimal) {
    self.id = id
    self.name = name
    self.date = date
    self.amount = amount
  }
}
