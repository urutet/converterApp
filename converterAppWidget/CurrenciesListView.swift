//
//  CurrenciesListView.swift
//  converterAppWidgetExtension
//
//  Created by user on 18.01.2023.
//

import SwiftUI
import WidgetKit

struct CurrenciesListView: View {
  var entry: CurrencyTimelineEntry
  var currenciesToShow: Int
  
  var body: some View {
    VStack {
      Divider()
      ForEach(entry.currencies.prefix(10)) { currency in
        HStack {
          Text(currency.abbreviation?.flagFromCurrency() ?? "")
          Text(currency.abbreviation ?? "")
            .bold()
          Spacer()
          Text(currency.rate?.toCurrencyString(currencyCode: currency.abbreviation!) ?? "")
        }
        .padding(.horizontal)
        Divider()
      }
    }
  }
}

struct CurrenciesListView_Previews: PreviewProvider {
  static var previews: some View {
    CurrenciesListView(entry: CurrencyTimelineEntry(currencies: [
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10.213123123123123123
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      ),
      Currency(
        id: 12,
        date: Date().formatted(),
        abbreviation: "USD",
        scale: 1,
        name: "US Dollar",
        rate: 10
      )
    ]), currenciesToShow: 5)
    .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
