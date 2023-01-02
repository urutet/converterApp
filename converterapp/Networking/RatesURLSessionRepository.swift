//
//  RatesURLSessionRepository.swift
//  converterapp
//
//  Created by user on 02.01.2023.
//

import Foundation

final class RatesURLSessionRepository: RatesRepositoryProtocol, AppDependencyProvider {
  private enum Constants {
    static let dateFormat = "yyyy-MM-dd"
  }
  
  weak var currenciesCache: CurrenciesCacheProtocol? = container.resolve(CurrenciesCacheProtocol.self)
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  
  init(currenciesCache: CurrenciesCacheProtocol?) {
    self.currenciesCache = currenciesCache
  }
  
  private let baseURL = "https://www.nbrb.by/api/exrates"
  private enum Endpoints {
    static let currencies = "/currencies"
    static let rates = "/rates"
    static let rateDynamics = "/rates/dynamics/"
  }
  
  private enum Parameters {
    static let periodicity = "periodicity"
    static let startDate = "startDate"
    static let endDate = "endDate"
  }
  
  private let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    
    let session = URLSession(configuration: configuration)
    
    return session
  }()
  
  private let decoder: JSONDecoder = JSONDecoder()
  
  func getRates(periodicity: Int, completion: @escaping ([Currency]) -> Void) {
    guard var components = URLComponents(string: baseURL + Endpoints.rates) else { return }
    components.queryItems = [
      URLQueryItem(name: Parameters.periodicity, value: String(periodicity))
    ]
    
    let request = URLRequest(url: components.url!)
    
    session.dataTask(with: request) { [weak self] data, response, error in
      guard let self else { return }
      
      if let error = error as? URLError {
        print("Error - \(error)")
        completion(self.pullCurrenciesFromCache())
        return
      }
      
      guard let data else {
        print("Body was empty")
        return
      }
      
      do {
        let rates = try self.decoder.decode([Currency].self, from: data)
        self.pushCurrenciesToCache(rates)
        completion(rates)
      } catch let error as NSError {
        print("Error - \(error)")
      }
    }.resume()
  }
  
  func getCurrencyDynamics(currencyID: Int, startDate: Date, endDate: Date, completion: @escaping ([Currency]) -> Void) {
    let formattedStartDate = dateFormatter.string(from: startDate)
    let formattedEndDate = dateFormatter.string(from: endDate)
    
    guard var components = URLComponents(string: baseURL + Endpoints.rateDynamics + String(currencyID)) else { return }
    components.queryItems = [
      URLQueryItem(name: Parameters.startDate, value: formattedStartDate),
      URLQueryItem(name: Parameters.endDate, value: formattedEndDate)
    ]
    
    let request = URLRequest(url: components.url!)
    
    session.dataTask(with: request) { [weak self] data, response, error in
      guard let self else { return }
      if let error = error as? URLError {
        print("Error - \(error)")
        completion(self.pullCurrenciesFromCache())
        return
      }
      
      guard let data else {
        print("Body was empty")
        return
      }
      
      do {
        let rates = try self.decoder.decode([Currency].self, from: data)
        completion(rates)
      } catch let error as NSError {
        print("Error - \(error)")
      }
    }.resume()
  }
  
  
  private func pushCurrenciesToCache(_ currencies: [Currency]) {
    if let favouriteCurrencies = currenciesCache?.pullFavourites() {
      let alteredRates = currencies.map { currency -> Currency in
        var currencyVar = currency
        if !favouriteCurrencies.filter({ $0.abbreviation == currencyVar.abbreviation }).isEmpty {
          currencyVar.isFavourite = true
        }
        return currencyVar
      }
      currenciesCache?.pushAllCurrencies(alteredRates)
    }
  }
  
  private func pullCurrenciesFromCache() -> [Currency] {
    guard let cachedCurrencies = currenciesCache?.pullAllCurrencies() else { return [] }
    guard let favouriteCurrencies = currenciesCache?.pullFavourites() else { return [] }
    let alteredRates = cachedCurrencies.map { currency -> Currency in
      var currencyVar = currency
      if !favouriteCurrencies
        .filter({ $0.abbreviation == currencyVar.abbreviation }).isEmpty {
        currencyVar.isFavourite = true
      }
      return currencyVar
    }
    return alteredRates
  }
}
