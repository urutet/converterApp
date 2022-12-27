//
//  CurrenciesCacheProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 14.07.22.
//

import Foundation

protocol CurrenciesCacheProtocol: AnyObject {
  func pushFavourites(_ currencies: [Currency])
  func pushAllCurrencies(_ currencies: [Currency])
  func pullFavourites() -> [Currency]?
  func pullAllCurrencies() -> [Currency]?
}
