//
//  RatesRepository.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Alamofire

final class RatesNetworkRepository: RatesRepositoryProtocol, AppDependencyProvider {
  private enum Constants {
    static let dateFormat = "yyyy-MM-dd"
  }
  
  var currenciesCache: CurrenciesCacheProtocol? = container.resolve(CurrenciesCacheProtocol.self)
  
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
  
  func getRates(periodicity: Int = 0, completion: @escaping ([Currency]) -> Void) {
    AF.request(baseURL + Endpoints.rates, parameters: [Parameters.periodicity : periodicity])
      .responseDecodable(of: [Currency].self) { [weak self] response in
        guard let strongSelf = self else { return }
        switch response.result {
        case .success(let rates):
          // Mapping favourites to one array
          if let favouriteCurrencies = strongSelf.currenciesCache?.pullFavourites() {
            let alteredRates = rates.map { currency -> Currency in
              var currencyVar = currency
              if !favouriteCurrencies.filter({ $0.abbreviation == currencyVar.abbreviation }).isEmpty {
                currencyVar.isFavourite = true
              }
              return currencyVar
            }
            strongSelf.currenciesCache?.pushAllCurrencies(rates)
            completion(alteredRates)
          }
          
        case .failure(_):
          // Mapping favourites to one array
          if let cachedCurrencies = strongSelf.currenciesCache?.pullAllCurrencies() {
            if let favouriteCurrencies = strongSelf.currenciesCache?.pullFavourites() {
              let alteredRates = cachedCurrencies.map { currency -> Currency in
                var currencyVar = currency
                if !favouriteCurrencies
                    .filter({ $0.abbreviation == currencyVar.abbreviation }).isEmpty {
                  currencyVar.isFavourite = true
                }
                return currencyVar
              }
              completion(alteredRates)
            }
          }
        }
        
      }
  }
  
  func getCurrencyDynamics(currencyID: Int, startDate: Date, endDate: Date, completion: @escaping ([Currency]) -> Void) {
    let formattedStartDate = dateFormatter.string(from: startDate)
    let formattedEndDate = dateFormatter.string(from: endDate)
    AF.request(
      baseURL + Endpoints.rateDynamics + String(currencyID),
      parameters: [Parameters.startDate : formattedStartDate, Parameters.endDate : formattedEndDate]
    )
      .responseDecodable(of: [Currency].self) { response in
        switch response.result {
        case .success(let rates):
          completion(rates)
        case .failure(let error):
          print(error)
        }
      }
  }
}
