//
//  RatesViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Combine
import Foundation

final class RatesViewModel {
  private enum Constants {
    static let favouritesStateKey = "favourites"
  }
  
  var coordinator: RatesCoordinator!
  var currencyRates = [Currency]()
  @Published var favouriteCurrencies = [Currency]()
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  private var subscriptions = Set<AnyCancellable>()
  
  func getRates() {
    ratesRepository.getRates(periodicity: 0) { [weak self] rates in
      guard let strongSelf = self else { return }
      
      strongSelf.currencyRates = rates
      
      strongSelf.favouriteCurrencies = strongSelf.currencyRates.filter { $0.isFavourite }
    }
  }
  
  func showCurrencyDetails(index: Int) {
    coordinator.goToCurrencyDetailsViewController(currency: favouriteCurrencies[index])
  }
  
  func goToFavourites() {
    let favouriteCurrenciesViewModel = coordinator
      .goToFavouriteCurrenciesViewController(currencies: currencyRates)
    
    favouriteCurrenciesViewModel.sendUpdatedCurrencies.sink { [weak self] updatedCurrencies in
      guard let strongSelf = self else { return }
      strongSelf.currencyRates = updatedCurrencies
      strongSelf.favouriteCurrencies = updatedCurrencies.filter { $0.isFavourite }
    }
    .store(in: &subscriptions)
  }
}
