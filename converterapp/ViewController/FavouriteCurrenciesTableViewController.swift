//
//  FavouriteTableCurrenciesViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 23.06.22.
//

import UIKit
import converterappCore
import EyeTracking

class FavouriteCurrenciesTableViewController: UITableViewController {
  // MARK: - Properties
  // MARK: Public
  var viewModel: FavouriteCurrenciesViewModel!
  // MARK: Private
  private enum Constants {
    static let cellIdentifier = "DefaultCell"
  }
  
  private let manager = TrackingManager.shared

  private let searchController: UISearchController = {
    let searchController = UISearchController()
    
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Strings.FavouriteCurrencies.searchCurrencies
    searchController.searchBar.scopeButtonTitles = [
      Strings.FavouriteCurrencies.allCurrencies,
      Strings.FavouriteCurrencies.favouriteCurrencies
    ]
    searchController.searchBar.showsScopeBar = true
    return searchController
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    searchController.searchBar.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsMultipleSelection = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeEyeTracking()
  }
  
  // MARK: - Setups
  private func setupEyeTracking() {
    manager.eyeTracker.setDelegate(self)
    manager.faceTracker.setDelegate(self)
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 0.4))
  }
  
  private func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 0.4))
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    title = Strings.FavouriteCurrencies.currencies
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Strings.FavouriteCurrencies.done,
      style: .done,
      target: self,
      action: #selector(favouritesChosen)
    )
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  @objc
  private func favouritesChosen() {
    viewModel.favouritesChosen()
  }
  
}

extension FavouriteCurrenciesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    super.tableView(tableView, numberOfRowsInSection: section)
    
    return viewModel.filteredCurrencies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    super.tableView(tableView, cellForRowAt: indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
    
    return configureCell(cell: cell, currency: viewModel.filteredCurrencies[indexPath.row])
  }
  
  private func configureCell(cell: UITableViewCell, currency: Currency) -> UITableViewCell {
    if #available(iOS 14.0, *) {
      var content = cell.defaultContentConfiguration()
      
      content.text = currency.name
      
      cell.contentConfiguration = content
    } else {
      cell.textLabel?.text = currency.name
    }
    
    cell.accessoryType = currency.isFavourite ? .checkmark : .none

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.toggleFavourite(selectedCurrency: viewModel.filteredCurrencies[indexPath.row])
    filterContentWithText(searchController)

  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    viewModel.toggleFavourite(selectedCurrency: viewModel.filteredCurrencies[indexPath.row])
    filterContentWithText(searchController)

  }
  
  func updateSearchResults(for searchController: UISearchController) {
    filterContentWithText(searchController)
  }
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentWithText(searchController)
  }
  
  private func filterContentWithText(_ searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    viewModel.filterCurrencies(searchText: text, scopeIndex: searchController.searchBar.selectedScopeButtonIndex)
    tableView.reloadData()
  }
}

extension FavouriteCurrenciesTableViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
      switch expression.blendShape {
      case .jawOpen:
        hitDone(at: point)
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
  
  private func hitDone(at point: CGPoint) {
    if navigationController?.visibleViewController == self {
      if CGRect(x: view.bounds.maxX - 100, y: 30, width: 100, height: 70).contains(point) {
        favouritesChosen()
        return
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
        viewModel.toggleFavourite(selectedCurrency: viewModel.filteredCurrencies[index.row])
        filterContentWithText(searchController)
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
