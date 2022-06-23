//
//  FavouriteCurrenciesCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 23.06.22.
//

import Foundation

final class FavouriteCurrenciesCoordinator: Coordinator {
  
  var rootCoordinator: RatesCoordinator!
  
  lazy var favouriteCurrenciesViewController = FavouriteCurrenciesTableViewController()
  weak var viewModel: FavouriteCurrenciesViewModel!

  func start() {
    viewModel.coordinator = self
    favouriteCurrenciesViewController.viewModel = viewModel
  }
  
  func pop() {
    rootCoordinator.rootViewController.popViewController(animated: true)
  }
  
}
