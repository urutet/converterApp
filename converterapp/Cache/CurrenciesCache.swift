//
//  CurrenciesCache.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 14.07.22.
//

import Foundation

final class CurrenciesCache: CurrenciesCacheProtocol {
  static let shared = CurrenciesCache()
  private let encoder = PropertyListEncoder()
  private init() { }
  
  private static let favouritesKey = "favourites"
  private static let allCurrenciesKey = "allCurrencies"
  
  func pushFavourites(_ currencies: [Currency]) {
    UserDefaults.standard.set(try? encoder.encode(currencies), forKey: CurrenciesCache.favouritesKey)
  }
  
  func pushAllCurrencies(_ currencies: [Currency]) {
    UserDefaults.standard.set(try? encoder.encode(currencies), forKey: CurrenciesCache.allCurrenciesKey)
  }
  
  func pullFavourites() -> [Currency]? {
    guard let data = UserDefaults.standard.value(forKey: CurrenciesCache.favouritesKey) as? Data else { return nil }
    let currencies = try? PropertyListDecoder().decode([Currency].self, from: data)
    return currencies
  }
  
  func pullAllCurrencies() -> [Currency]? {
    guard let data = UserDefaults.standard.value(forKey: CurrenciesCache.allCurrenciesKey) as? Data else { return nil }
    let currencies = try? PropertyListDecoder().decode([Currency].self, from: data)
    return currencies
  }
}
