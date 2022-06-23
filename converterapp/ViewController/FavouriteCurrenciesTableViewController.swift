//
//  FavouriteTableCurrenciesViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 23.06.22.
//

import UIKit

class FavouriteCurrenciesTableViewController: UITableViewController {
  // MARK: - Properties
  // MARK: Public
  var viewModel: FavouriteCurrenciesViewModel!
  // MARK: Private
  private enum Constants {
    static let cellIdentifier = "DefaultCell"
  }
  private let searchController: UISearchController = {
    let searchController = UISearchController()
    
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Currencies"
    searchController.searchBar.scopeButtonTitles = ["All Currencies", "Favourite Currencies"]
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
  
  // MARK: - Setups
  private func setupUI() {
    view.backgroundColor = .white
    title = "Currencies"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Done",
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
