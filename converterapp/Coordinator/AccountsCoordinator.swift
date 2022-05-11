//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AccountsCoordinator: Coordinator {
  
  let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var accountsViewController: AccountsViewController = AccountsViewController()
  weak var viewModel: AccountsViewModel!

  func start() {
    accountsViewController.viewModel = viewModel
    accountsViewController.viewModel.coordinator = self
    rootViewController.setViewControllers([accountsViewController], animated: false)

  }
  
  func goToAddAccountViewController() -> AddAccountViewModel {
    let addAccountViewController = AddAccountViewController()
    let addAccountViewModel = AddAccountViewModel()
    addAccountViewController.viewModel = addAccountViewModel
    rootViewController.pushViewController(addAccountViewController, animated: true)
    return addAccountViewModel
  }
  
  func pop() {
    rootViewController.popViewController(animated: true)
  }
  
}
