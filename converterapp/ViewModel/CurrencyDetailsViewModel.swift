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
  var defaultEntries = [ChartDataEntry]()
  var currencyDynamicsData = PassthroughSubject<ChartData, Never>()
  
  private let ratesRepository: RatesRepositoryProtocol = RatesNetworkRepository.shared
  
  func getCurrencyDynamics() {
    guard
      let id = currency.id,
      let startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
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
      
      strongSelf.defaultEntries = rateEntries
      
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
  
  func currencyDynamicsChanged(selectedIndex: Int) {
    var dateToScale: Date?
    switch selectedIndex {
    case 0:
      dateToScale = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    case 1:
      dateToScale = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    case 2:
      dateToScale = Calendar.current.date(byAdding: .month, value: -6, to: Date())
    case 3:
      dateToScale = Calendar.current.date(byAdding: .year, value: -1, to: Date())
    default:
      assertionFailure("Index not implemented")
    }
    
    guard let dateToScale = dateToScale else { return }
    
    let scaledEntries = defaultEntries.filter { $0.x >= Double(Int(dateToScale.timeIntervalSince1970)) }
    
    let dataSet = LineChartDataSet(entries: scaledEntries)
    dataSet.mode = .cubicBezier
    dataSet.drawCirclesEnabled = false
    dataSet.lineWidth = 3
    dataSet.setColor(.systemGray)
    dataSet.drawFilledEnabled = true
    dataSet.fill = ColorFill(color: .systemGray)

    let chartData = LineChartData(dataSet: dataSet)
    
    currencyDynamicsData.send(chartData)
  }
}
