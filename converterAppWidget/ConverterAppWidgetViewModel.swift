//
//  ConverterAppWidgetViewModel.swift
//  converterAppWidgetExtension
//
//  Created by user on 18.01.2023.
//

import Foundation
import Combine

@MainActor
final class ConverterAppWidgetViewModel: ObservableObject {
  @Published private(set) var entry: CurrencyTimelineEntry = CurrencyTimelineEntry(date: Date(), currencies: [])
  private let url = URL(string: "https://www.nbrb.by/api/exrates/rates?periodicity=0")!
  private let decoder = JSONDecoder()
  private var subscriptions = Set<AnyCancellable>()
  
  func getData() {
    URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: [Currency].self, decoder: decoder)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: {
          print ("Received completion 1: \($0).")
        },
        receiveValue: { [weak self] currencies in
          self?.entry = CurrencyTimelineEntry(currencies: currencies)
        }
      )
      .store(in: &subscriptions)
  }
}
