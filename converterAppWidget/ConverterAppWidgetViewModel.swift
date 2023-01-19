//
//  ConverterAppWidgetViewModel.swift
//  converterAppWidgetExtension
//
//  Created by user on 18.01.2023.
//

import Foundation
import Combine
import converterappCore

@MainActor
final class ConverterAppWidgetViewModel: ObservableObject {
  @Published private(set) var entry: CurrencyTimelineEntry = CurrencyTimelineEntry(date: Date(), currencies: [])
  private var ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository(currenciesCache: CurrenciesCache())
  
  func getData() {
    ratesRepository.getRates(periodicity: 0) { [weak self] currencies in
      self?.entry.date = Date()
      self?.entry.currencies = currencies
    }
  }
}
