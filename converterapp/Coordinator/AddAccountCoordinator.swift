//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AddAccountCoordinator: Coordinator {
  
  var rootCoordinator: AccountsCoordinator!
  
  lazy var addAccountViewController: AddAccountViewController = AddAccountViewController()
  weak var viewModel: AddAccountViewModel!

  func start() {
    addAccountViewController.viewModel = viewModel
    addAccountViewController.viewModel.coordinator = self

  }
  
  func pop() {
    rootCoordinator.rootViewController.popViewController(animated: true)
  }
  
  func getRootViewController() -> UIViewController {
    addAccountViewController
  }
}
