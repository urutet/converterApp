//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AccountDetailsCoordinator: Coordinator {
  
  var rootCoordinator: AccountsCoordinator!
  
  lazy var accountDetailsViewController: AccountDetailsViewController = AccountDetailsViewController()
  weak var viewModel: AccountDetailsViewModel!

  func start() {
    accountDetailsViewController.viewModel = viewModel
    accountDetailsViewController.viewModel.coordinator = self

  }
  
  func goToAddTransactionViewController() -> AddTransactionViewModel {
    let addTransactionViewController = AddTransactionViewController()
    let addTransationViewModel = AddTransactionViewModel()
    let addTransactionCoordinator = AddTransactionCoordinator()
    
    addTransactionCoordinator.addTransactionViewController = addTransactionViewController
    addTransactionCoordinator.viewModel = addTransationViewModel
    addTransactionCoordinator.rootCoordinator = self
    addTransactionCoordinator.start()
    rootCoordinator.rootViewController.pushViewController(addTransactionViewController, animated: true)
    
    return addTransationViewModel
  }
}
