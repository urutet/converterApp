//
//  RatesCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit
import Swinject

final class RatesCoordinator: Coordinator {
  
  weak var viewModel: RatesViewModel!
  let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var ratesViewController = RatesViewController()
  
  func start() {
    viewModel.coordinator = self
    ratesViewController.viewModel = viewModel
    rootViewController.setViewControllers([ratesViewController], animated: false)
  }
  
  func goToCurrencyDetailsViewController(currency: Currency) {
    let currencyDetailsViewController = CurrencyDetailsViewController()
    
    let currencyDetailsCoordinator = CurrencyDetailsCoordinator()
    currencyDetailsCoordinator.rootCoordinator = self
    
    let currencyDetailsViewModel = CurrencyDetailsViewModel()
    currencyDetailsViewModel.currency = currency
    currencyDetailsViewModel.coordinator = currencyDetailsCoordinator
    
    currencyDetailsCoordinator.currencyDetailsViewController = currencyDetailsViewController
    currencyDetailsCoordinator.viewModel = currencyDetailsViewModel
    currencyDetailsCoordinator.start()
    rootViewController.pushViewController(currencyDetailsViewController, animated: true)
  }
  
  func goToFavouriteCurrenciesViewController(currencies: [Currency]) -> FavouriteCurrenciesViewModel {
    let favouriteCurrenciesViewController = FavouriteCurrenciesTableViewController()
    
    let favouriteCurrenciesCoordinator = FavouriteCurrenciesCoordinator()
    favouriteCurrenciesCoordinator.rootCoordinator = self
    
    let favouriteCurrenciesViewModel = FavouriteCurrenciesViewModel()
    favouriteCurrenciesViewModel.coordinator = favouriteCurrenciesCoordinator
    favouriteCurrenciesViewModel.currencies = currencies
    favouriteCurrenciesViewModel.filteredCurrencies = currencies
    favouriteCurrenciesCoordinator.favouriteCurrenciesViewController = favouriteCurrenciesViewController
    favouriteCurrenciesCoordinator.viewModel = favouriteCurrenciesViewModel
    favouriteCurrenciesCoordinator.start()
    
    rootViewController.pushViewController(favouriteCurrenciesViewController, animated: true)
    
    return favouriteCurrenciesViewModel
  }
}
