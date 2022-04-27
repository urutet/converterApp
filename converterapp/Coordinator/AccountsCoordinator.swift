//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AccountsCoordinator: Coordinator {
  
  private let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var accountsViewController: AccountsViewController = {
    let accountsViewController = AccountsViewController()
    
    return accountsViewController
  }()
  
  func start() {
    rootViewController.setViewControllers([accountsViewController], animated: false)

  }
  
}
