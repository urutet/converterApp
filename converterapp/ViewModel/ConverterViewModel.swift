//
//  ConverterViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Combine

final class ConverterViewModel {
  @Published var currencies = [Currency]()
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  func getRates() {
    ratesRepository.getRates(periodicity: 0) { [weak self] currencies in
      self?.currencies = currencies
    }
  }
}
