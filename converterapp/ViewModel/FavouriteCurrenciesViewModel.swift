//
//  FavouriteCurrenciesViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 23.06.22.
//

import Foundation
import Combine

class FavouriteCurrenciesViewModel {
  var coordinator: FavouriteCurrenciesCoordinator!
  var currencies = [Currency]()
  var filteredCurrencies = [Currency]()
  var sendUpdatedCurrencies = PassthroughSubject<[Currency], Never>()
  
  func filterCurrencies(searchText: String, scopeIndex: Int) {
    if scopeIndex == 0 {
      filteredCurrencies = currencies.filter({ currency in
        guard let name = currency.name else { return false }
        return (name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty)
      })
    } else {
      filteredCurrencies = currencies
        .filter({ currency in
          guard let name = currency.name else { return false }
          return (name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty) && currency.isFavourite
        })
    }
  }
  
  func toggleFavourite(selectedCurrency: Currency) {
    currencies = currencies.map { currency in
      guard
        let currencyName = currency.name,
        let selectedCurrencyName = selectedCurrency.name,
        currencyName == selectedCurrencyName
      else { return currency }
      
      var selectedCurrency = currency
      selectedCurrency.isFavourite = !selectedCurrency.isFavourite
      
      return selectedCurrency
    }
  }
  
  func favouritesChosen() {
    sendUpdatedCurrencies.send(currencies)
    coordinator.pop()
  }
}
