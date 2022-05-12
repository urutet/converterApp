//
//  RatesViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Combine
import Foundation

final class RatesViewModel {
  @Published var currencyRates = [Currency]()
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  
  func getRates() {
    ratesRepository.getRates(periodicity: 0) { [weak self] rates in
      self?.currencyRates = rates
    }
  }
}
