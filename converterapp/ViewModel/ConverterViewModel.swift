//
//  ConverterViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Combine
import Foundation

final class ConverterViewModel {
  var currencies = [Currency]() {
    didSet {
      converterCellViewModels = [ConverterCellViewModel]()
      for currency in currencies {
        let converterCellViewModel = ConverterCellViewModel()
        converterCellViewModel.currency = currency
        converterCellViewModels.append(converterCellViewModel)
      }
    }
  }
  
  @Published var converterCellViewModels = [ConverterCellViewModel]()
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  
  func getRates() {
    ratesRepository.getRates(periodicity: 0) { [weak self] currencies in
      self?.currencies = currencies
    }
  }
}
