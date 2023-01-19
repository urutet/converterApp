//
//  converterAppWidget.swift
//  converterAppWidget
//
//  Created by user on 17.01.2023.
//

import WidgetKit
import SwiftUI
import converterappCore

struct Provider: TimelineProvider {
  @StateObject var viewModel = ConverterAppWidgetViewModel()

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
    viewModel.getData()
    
    let nextUpdate = Calendar.current.date(byAdding: .second, value: 10, to: viewModel.entry.date)
    
    let timeline = Timeline(entries: [viewModel.entry], policy: .after(nextUpdate!))
    
    completion(timeline)
  }
}

struct converterAppWidgetEntryView : View {
  @Environment(\.widgetFamily) var family: WidgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    switch family {
    case .systemSmall:
      CurrenciesListView(entry: entry, currenciesToShow: 2)
    case .systemMedium:
      CurrenciesListView(entry: entry, currenciesToShow: 3)
    case .systemLarge:
      CurrenciesListView(entry: entry, currenciesToShow: 8)
    case .systemExtraLarge:
      CurrenciesListView(entry: entry, currenciesToShow: 8)
    case .accessoryCorner:
      CurrenciesListView(entry: entry, currenciesToShow: 2)
    case .accessoryCircular:
      CurrenciesListView(entry: entry, currenciesToShow: 2)
    case .accessoryRectangular:
      CurrenciesListView(entry: entry, currenciesToShow: 2)
    case .accessoryInline:
      CurrenciesListView(entry: entry, currenciesToShow: 2)
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
