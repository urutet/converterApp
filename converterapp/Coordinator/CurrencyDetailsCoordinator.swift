//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 13.06.22.
//

import UIKit

final class CurrencyDetailsCoordinator: Coordinator {
  
  var rootCoordinator: RatesCoordinator!
  
  lazy var currencyDetailsViewController: CurrencyDetailsViewController = CurrencyDetailsViewController()
  weak var viewModel: CurrencyDetailsViewModel!

  func start() {
    viewModel.coordinator = self
    currencyDetailsViewController.viewModel = viewModel
  }
  
  func pop() {
    rootCoordinator.rootViewController.popViewController(animated: true)
  }
  
  func getRootViewController() -> UIViewController {
    currencyDetailsViewController
  }
}
