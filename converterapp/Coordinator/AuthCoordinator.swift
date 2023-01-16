//
//  AuthCoordinator.swift
//  converterapp
//
//  Created by user on 12.01.2023.
//

import Foundation
import UIKit

final class AuthCoordinator: Coordinator {
  
  private enum Constants {
    static let accountsImage = UIImage(systemName: "person.crop.circle")
    static let accountsSelectedImage = UIImage(systemName: "person.crop.circle.fill")
  }
  
  var parentCoordinator: MainCoordinator!
  
  var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var authViewController: AuthViewController = AuthViewController()
  weak var viewModel: AuthViewModel!
  
  func start() {
    authViewController.viewModel = viewModel
    authViewController.viewModel.coordinator = self
    rootViewController.setViewControllers([authViewController], animated: false)
    
  }
  
  func getRootViewController() -> UIViewController {
    rootViewController
  }
}
