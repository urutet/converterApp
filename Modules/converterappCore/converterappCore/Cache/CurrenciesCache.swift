//
//  CurrenciesCache.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 14.07.22.
//

import Foundation

public final class CurrenciesCache: CurrenciesCacheProtocol {
  
  private let encoder = PropertyListEncoder()
  
  private static let favouritesKey = "favourites"
  private static let allCurrenciesKey = "allCurrencies"
  
  public func pushFavourites(_ currencies: [Currency]) {
    UserDefaults.standard.set(try? encoder.encode(currencies), forKey: CurrenciesCache.favouritesKey)
  }
  
  public func pushAllCurrencies(_ currencies: [Currency]) {
    UserDefaults.standard.set(try? encoder.encode(currencies), forKey: CurrenciesCache.allCurrenciesKey)
  }
  
  public func pullFavourites() -> [Currency]? {
    guard let data = UserDefaults.standard.value(forKey: CurrenciesCache.favouritesKey) as? Data else { return nil }
    let currencies = try? PropertyListDecoder().decode([Currency].self, from: data)
    return currencies
  }
  
  public func pullAllCurrencies() -> [Currency]? {
    guard let data = UserDefaults.standard.value(forKey: CurrenciesCache.allCurrenciesKey) as? Data else { return nil }
    let currencies = try? PropertyListDecoder().decode([Currency].self, from: data)
    return currencies
  }
}
