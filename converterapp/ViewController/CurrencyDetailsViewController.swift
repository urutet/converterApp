//
//  CurrencyDetailsViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 13.06.22.
//

import UIKit
import Charts
import Combine
import EyeTracking

class CurrencyDetailsViewController: UIViewController {
  // MARK: - Properties
  // MARK: Public
  var viewModel: CurrencyDetailsViewModel!
  let manager = TrackingManager.shared
  
  // MARK: Private
  private var subscriptions = Set<AnyCancellable>()
  private let chartView: LineChartView = {
    let chartView = LineChartView()
    chartView.translatesAutoresizingMaskIntoConstraints = false
    
    chartView.xAxis.labelPosition = .bottom
    chartView.xAxis.labelFont = FontsManager.bold(ofSize: 12)
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.xAxis.valueFormatter = ChartDateFormatter()

    chartView.leftAxis.enabled = false
    
    chartView.rightAxis.labelFont = FontsManager.bold(ofSize: 12)
    chartView.rightAxis.gridColor = .systemGray
    
    chartView.drawBordersEnabled = false
    chartView.legend.enabled = false
    
    return chartView
  }()
  
  private let dynamicsRangeSegmentedControl: SegmentedControl = {
    let segmentedControl = SegmentedControl(items: [
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeEyeTracking()
    super.viewWillDisappear(true)
  }
  
  private func setupEyeTracking() {
      manager.eyeTracker.setDelegate(self)
      manager.faceTracker.setDelegate(self)
      manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.5, maxValue: 1))
  }
  
  private func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
      manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.5, maxValue: 1))

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

extension CurrencyDetailsViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn:
      guard let expression else { return }
      switch expression.blendShape {
      case .mouthSmileLeft:
          navigationController?.popViewController(animated: true)
      default:
        return
      }
    case .screenOut:
      return
      }
    }
  
  public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
    manager.eyeTracker.delegates.forEach { delegate in
      delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
    }
  }
}
