//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AddTransactionCoordinator: Coordinator {
  
  var rootCoordinator: AccountDetailsCoordinator!
  
  lazy var addTransactionViewController: AddTransactionViewController = AddTransactionViewController()
  weak var viewModel: AddTransactionViewModel!

  func start() {
    addTransactionViewController.viewModel = viewModel
    addTransactionViewController.viewModel.coordinator = self

  }
  
  func pop() {
    rootCoordinator.rootCoordinator.rootViewController.popViewController(animated: true)
  }
  
  func getRootViewController() -> UIViewController {
    addTransactionViewController
  }
}
