//
//  Decimal+Extensions.swift
//  converterapp
//
//  Created by user on 17.01.2023.
//

import Foundation

extension Decimal {
  static let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
  func toCurrencyString(currencyCode: String) -> String {
    Decimal.currencyFormatter.currencyCode = currencyCode
    return Decimal.currencyFormatter.string(from: self as NSNumber) ?? ""
  }
}
