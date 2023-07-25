//
//  RatesViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import Combine
import EyeTracking

final class RatesViewController: UIViewController {

  // MARK: - Properties
  // MARK: Public
  var viewModel: RatesViewModel!
  // MARK: Private
  private enum Constants {
    static let rateCellIdentifier = "RateTableViewCell"
  }
  
  private let manager = TrackingManager.shared
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(RateTableViewCell.self, forCellReuseIdentifier: Constants.rateCellIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  
  private let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    
    return refreshControl
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addSubviews()
    addConstraints()
    setupSubscriptions()
    addTargets()
    viewModel.getRates()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeEyeTracking()
  }
  
  // MARK: - API
  // MARK: - Setups
  private func setupEyeTracking() {
    manager.eyeTracker.setDelegate(self)
    manager.faceTracker.setDelegate(self)
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))

  }
  
  private func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
  }
  
  private func setupUI() {
    title = Strings.Rates.title
    view.backgroundColor = .systemBackground
    
//    navigationItem.rightBarButtonItem = UIBarButtonItem(
//      barButtonSystemItem: .add,
//      target: self,
//      action: #selector(selectFavourites)
//    )
  }
  
  private func setupSubscriptions() {
    viewModel.$favouriteCurrencies
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
      self?.tableView.reloadData()
    }
    .store(in: &subscriptions)
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
    tableView.refreshControl = refreshControl
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  private func addTargets() {
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
  }
  // MARK: - Helpers
  @objc
  private func refresh(sender: UIRefreshControl) {
    viewModel.getRates()
    sender.endRefreshing()
  }
  
  @objc
  private func selectFavourites() {
    viewModel.goToFavourites()
  }
}

extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.favouriteCurrencies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.rateCellIdentifier) as? RateTableViewCell
    else { return UITableViewCell() }
    
    cell.setRate(currency: viewModel.favouriteCurrencies[indexPath.row])
    
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.showCurrencyDetails(index: indexPath.row)
  }
  
}

extension RatesViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
      switch expression.blendShape {
      case .jawOpen:
        hitCell(at: point)
      default:
        return
      }
    case .screenOut(let edge, _):
      switch edge {
      case .left, .right:
        return
      case .top:
        scrollTableView(-6)
      case .bottom:
        scrollTableView(6)

      }
    }
  }
  
  private func hitCell(at point: CGPoint) {
    if navigationController?.visibleViewController != self {
      if CGRect(x: 0, y: 30, width: 100, height: 70).contains(point) {
        navigationController?.popViewController(animated: true)
        return
      }
    } else {
      if let index = tableView.indexPathForRow(at: view.convert(point, to: tableView)) {
        viewModel.showCurrencyDetails(index: index.row)
        return
      }
    }
  }
  
  private func scrollTableView(_ y: CGFloat) {
    var nextContentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + y)
    nextContentOffset.y = min(max(nextContentOffset.y, 0), tableView.contentSize.height - tableView.bounds.height)
    tableView.setContentOffset(nextContentOffset, animated: false)
  }
  
  public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
    manager.eyeTracker.delegates.forEach { delegate in
      delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
    }
  }
}
