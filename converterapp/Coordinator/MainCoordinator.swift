//
//  MainCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class MainCoordinator: Coordinator {
  
  private enum Constants {
    static let ratesImage = UIImage(systemName: "dollarsign.circle")
    static let ratesSelectedImage = UIImage(systemName: "dollarsign.circle.fill")
    static let converterImage = UIImage(systemName: "repeat.circle")
    static let converterSelectedImage = UIImage(systemName: "repeat.circle.fill")
    static let accountsImage = UIImage(systemName: "person.crop.circle")
    static let accountsSelectedImage = UIImage(systemName: "person.crop.circle.fill")
  }
  
  let rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    
    tabBarController.view.backgroundColor = .systemBackground
    
    return tabBarController
  }()
  
  var childCoordinators = [Coordinator]()
  
  func start() {
    let ratesCoordinator = RatesCoordinator()
    ratesCoordinator.start()
    ratesCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.rates,
      image: Constants.ratesImage,
      selectedImage: Constants.ratesSelectedImage
    )
    
    let converterCoordinator = ConverterCoordinator()
    converterCoordinator.start()
    converterCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.converter,
      image: Constants.converterImage,
      selectedImage: Constants.converterSelectedImage
    )
    
    let accountsCoordinator = AccountsCoordinator()
    let accountsViewModel = AccountsViewModel()
    accountsCoordinator.viewModel = accountsViewModel
    accountsCoordinator.start()
    accountsCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.accounts,
      image: Constants.accountsImage,
      selectedImage: Constants.accountsSelectedImage
    )
    
    childCoordinators = [ratesCoordinator, converterCoordinator, accountsCoordinator]
    
    rootViewController.viewControllers = [
      ratesCoordinator.rootViewController,
      converterCoordinator.rootViewController,
      accountsCoordinator.rootViewController
    ]
  }
}
