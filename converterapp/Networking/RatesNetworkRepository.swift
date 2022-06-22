//
//  RatesRepository.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Alamofire

final class RatesNetworkRepository: RatesRepositoryProtocol {
  private enum Constants {
    static let dateFormat = "yyyy-MM-dd"
  }
  
  static let shared = RatesNetworkRepository()
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  
  private init() { }
  
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
      .responseDecodable(of: [Currency].self) { response in
        switch response.result {
        case .success(let rates):
          completion(rates)
        case .failure(let error):
          print(error)
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
