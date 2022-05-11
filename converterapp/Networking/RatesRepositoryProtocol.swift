//
//  RatesRepositoryProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

protocol RatesRepositoryProtocol {
  func getRates(periodicity: Int, completion: @escaping ([Currency]) -> Void)
}
