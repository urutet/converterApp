//
//  CurrencyDetailsViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 13.06.22.
//

import UIKit
import Charts
import Combine

class CurrencyDetailsViewController: UIViewController {
  // MARK: - Properties
  // MARK: Public
  var viewModel: CurrencyDetailsViewModel!
  
  // MARK: Private
  private var subscriptions = Set<AnyCancellable>()
  private let chartView: LineChartView = {
    let chartView = LineChartView()
    chartView.translatesAutoresizingMaskIntoConstraints = false
    
    chartView.xAxis.labelPosition = .bottom
    chartView.xAxis.labelFont = FontsManager.bold(ofSize: 12)
    chartView.xAxis.drawGridLinesEnabled = false
    
    chartView.leftAxis.enabled = false
    
    chartView.rightAxis.labelFont = FontsManager.bold(ofSize: 12)
    chartView.rightAxis.gridColor = .systemGray
    
    chartView.drawBordersEnabled = false
    chartView.legend.enabled = false
    
    return chartView
  }()
  
  private let dynamicsRangeSegmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: [
      Strings.CurrencyDetails._7Days,
      Strings.CurrencyDetails._1Month,
      Strings.CurrencyDetails._6Months,
      Strings.CurrencyDetails.year
    ])
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.addTarget(self, action: #selector(selectedSegmentIndexChanged), for: .valueChanged)
    
    segmentedControl.selectedSegmentIndex = 3
    return segmentedControl
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addSubviews()
    addConstraints()
    addSubscriptions()
    
    viewModel.getCurrencyDynamics()
  }
  
  // MARK: - Setups
  private func setupUI() {
    view.backgroundColor = .systemBackground
    title = viewModel.currency.abbreviation
  }
  
  private func addSubviews() {
    view.addSubview(chartView)
    view.addSubview(dynamicsRangeSegmentedControl)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      chartView.heightAnchor.constraint(equalToConstant: 200),
      chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      dynamicsRangeSegmentedControl.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
      dynamicsRangeSegmentedControl.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
      dynamicsRangeSegmentedControl.trailingAnchor.constraint(equalTo: chartView.trailingAnchor)
    ])
  }
  
  private func addSubscriptions() {
    viewModel.currencyDynamicsData
      .sink { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.chartView.data = $0
      }
      .store(in: &subscriptions)
  }
  
  // MARK: - Helpers
  @objc
  private func selectedSegmentIndexChanged() {
    viewModel.currencyDynamicsChanged(selectedIndex: dynamicsRangeSegmentedControl.selectedSegmentIndex)
  }
}
