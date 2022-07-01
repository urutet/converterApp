//
//  ConverterCellViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 24.06.22.
//

import Foundation
import Combine

final class ConverterCellViewModel {
  @Published var currency: Currency!
  var calculatedValue = PassthroughSubject<Decimal, Never>()
  
  func convertCurrency(amount: Decimal) {
    guard let rate = currency.rate else { return }
    calculatedValue.send(amount * rate)
  }
}
