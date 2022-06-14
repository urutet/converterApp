//
//  RatesRepositoryProtocol.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//
import Foundation

protocol RatesRepositoryProtocol {
  func getRates(periodicity: Int, completion: @escaping ([Currency]) -> Void)
  func getCurrencyDynamics(currencyID: Int, startDate: Date, endDate: Date, completion: @escaping ([Currency]) -> Void)
}
