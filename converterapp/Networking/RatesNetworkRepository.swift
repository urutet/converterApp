//
//  RatesRepository.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import Alamofire

final class RatesNetworkRepository: RatesRepositoryProtocol {
  static let shared = RatesNetworkRepository()
  
  private init() { }
  
  private let baseURL = "https://www.nbrb.by/api/exrates"
  private enum Endpoints {
    static let currencies = "/currencies"
    static let rates = "/rates"
  }
  
  private enum Parameters {
    static let periodicity = "periodicity"
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
}
