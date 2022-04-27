//
//  Account.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import Foundation

struct Account {
  let name: String
  let currency: String
  let balance: Decimal
  let transactions: [Transaction]
}
