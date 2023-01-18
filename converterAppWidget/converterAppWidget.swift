//
//  converterAppWidget.swift
//  converterAppWidget
//
//  Created by user on 17.01.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> CurrencyTimelineEntry {
    CurrencyTimelineEntry(
      date: Date(),
      currencies: [
        Currency(
          id: 12,
          date: Date().formatted(),
          abbreviation: "USD",
          scale: 1,
          name: "US Dollar"
        )
      ]
    )
  }
  
  func getSnapshot(in context: Context, completion: @escaping (CurrencyTimelineEntry) -> ()) {
    let entry = CurrencyTimelineEntry(
      date: Date(),
      currencies: [
        Currency(
          id: 12,
          date: Date().formatted(),
          abbreviation: "USD",
          scale: 1,
          name: "US Dollar",
          rate: 10
        )
      ]
    )
    completion(entry)
  }
  
  @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    @StateObject var viewModel = ConverterAppWidgetViewModel()
    
    viewModel.getData()
    
    let timeline = Timeline(entries: [viewModel.entry], policy: .atEnd)
    completion(timeline)
  }
}

struct converterAppWidgetEntryView : View {
  var entry: Provider.Entry
  
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

struct converterAppWidget: Widget {
  let kind: String = "converterAppWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      converterAppWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("ConverterApp widget")
    .description("Widget with your favourite currencies.")
  }
}

struct converterAppWidget_Previews: PreviewProvider {
  static var previews: some View {
    converterAppWidgetEntryView(entry: CurrencyTimelineEntry(
      date: Date(),
      currencies: [
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
      ]
    )
    )
    .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
