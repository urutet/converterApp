//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit
import converterappCore

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
    addAccountViewModel.controllerType = .add
    let addAccountCoordinator = AddAccountCoordinator()
    
    addAccountCoordinator.viewModel = addAccountViewModel
    addAccountCoordinator.addAccountViewController = addAccountViewController
    addAccountCoordinator.start()
    rootViewController.pushViewController(addAccountViewController, animated: true)
    
    return addAccountViewModel
  }
  
  func goToAccountDetailsViewController(index: Int) -> AccountDetailsViewModel {
    let accountDetailsViewController = AccountDetailsViewController()
    let accountDetailsViewModel = AccountDetailsViewModel()
    let accountDetailsCoordinator = AccountDetailsCoordinator()
    
    accountDetailsCoordinator.accountDetailsViewController = accountDetailsViewController
    accountDetailsViewModel.account = viewModel.accounts[index]
    accountDetailsCoordinator.viewModel = accountDetailsViewModel
    accountDetailsCoordinator.rootCoordinator = self
    accountDetailsCoordinator.start()
    
    rootViewController.pushViewController(accountDetailsViewController, animated: true)
    
    return accountDetailsViewModel
  }
  
  func goToEditAccountViewController(account: Account) -> AddAccountViewModel {
    let addAccountViewController = AddAccountViewController()
    let addAccountViewModel = AddAccountViewModel()
    addAccountViewModel.controllerType = .edit
    addAccountViewModel.setAccount(account: account)
    let addAccountCoordinator = AddAccountCoordinator()
    
    addAccountCoordinator.viewModel = addAccountViewModel
    addAccountCoordinator.addAccountViewController = addAccountViewController
    addAccountCoordinator.start()
    rootViewController.pushViewController(addAccountViewController, animated: true)
    
    return addAccountViewModel
  }
  
  func pop() {
    rootViewController.popViewController(animated: true)
  }
  
  func getRootViewController() -> UIViewController {
    rootViewController
  }
}
