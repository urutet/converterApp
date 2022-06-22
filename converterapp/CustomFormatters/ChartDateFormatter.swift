//
//  ChartDateFormatter.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 22.06.22.
//

import Foundation
import Charts

class ChartDateFormatter: NSObject, AxisValueFormatter {
  private enum Constants {
    static let dateFormat = "MMM YY"
  }
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    dateFormatter.string(from: Date(timeIntervalSince1970: value))
  }
}
