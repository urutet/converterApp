//
//  AccountsCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class AccountDetailsCoordinator: Coordinator {
  
  var rootViewController: UINavigationController!
  
  lazy var accountDetailsViewController: AccountDetailsViewController = AccountDetailsViewController()
  weak var viewModel: AccountDetailsViewModel!

  func start() {
    accountDetailsViewController.viewModel = viewModel
    accountDetailsViewController.viewModel.coonrdinator = self

  }
  
}
