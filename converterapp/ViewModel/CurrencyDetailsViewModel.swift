//
//  RatesViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 13.06.22.
//

import Foundation
import Charts
import Combine

final class CurrencyDetailsViewModel {
  private enum Constants {
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
  }
  var coordinator: CurrencyDetailsCoordinator!
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  var currency: Currency!
  var currencyDynamicsData = PassthroughSubject<ChartData, Never>()
  
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  
  func getCurrencyDynamics() {
    guard
      let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()),
      let id = currency.id
    else { return }
    
    ratesRepository.getCurrencyDynamics(
      currencyID: id,
      startDate: startDate,
      endDate: Date()
    ) { [weak self] currencyDynamics in
      guard let strongSelf = self else { return }
      
      let rateEntries = currencyDynamics.map { (currency) -> ChartDataEntry in
        guard
          let date = strongSelf.dateFormatter.date(from: currency.date)?.timeIntervalSince1970,
          let rate = currency.rate as NSDecimalNumber?
        else { return ChartDataEntry() }

        return ChartDataEntry(x: Double(Int(date)), y: rate.doubleValue)
      }
      
      let dataSet = LineChartDataSet(entries: rateEntries)
      dataSet.mode = .cubicBezier
      dataSet.drawCirclesEnabled = false
      dataSet.lineWidth = 3
      dataSet.setColor(.systemGray)
      dataSet.drawFilledEnabled = true
      dataSet.fill = ColorFill(color: .systemGray)
      
      let chartData = LineChartData(dataSet: dataSet)
      
      strongSelf.currencyDynamicsData.send(chartData)
    }
  }
}
