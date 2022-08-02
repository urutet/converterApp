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
  var selectedCurrency: Currency!
  var isSelected = false
  
  func convertCurrency(amount: Decimal) {
    guard
      let rate = currency.rate,
      let selectedCurrencyRate = selectedCurrency.rate
    else { return }
    
    calculatedValue.send(amount * (selectedCurrencyRate / rate))
  }
}
