//
//  CurrencyTimelineModel.swift
//  converterAppWidgetExtension
//
//  Created by user on 18.01.2023.
//

import Foundation
import WidgetKit

final class CurrencyTimelineEntry: TimelineEntry {
  var date: Date
  var currencies: [Currency]
  
  init(date: Date = Date(), currencies: [Currency]) {
    self.date = date
    self.currencies = currencies
  }
}
