//
//  MainCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class MainCoordinator: Coordinator {
  
  private enum Constants {
    static let ratesTitle = "Rates"
    static let ratesImage = UIImage(systemName: "dollarsign.circle")
    static let ratesSelectedImage = UIImage(systemName: "dollarsign.circle.fill")
    static let converterTitle = "Converter"
    static let converterImage = UIImage(systemName: "repeat.circle")
    static let converterSelectedImage = UIImage(systemName: "repeat.circle.fill")
    static let accountsTitle = "Accounts"
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
    ratesCoordinator.ratesViewController.tabBarItem = UITabBarItem(
      title: Constants.ratesTitle,
      image: Constants.ratesImage,
      selectedImage: Constants.ratesSelectedImage
    )
    
    let converterCoordinator = ConverterCoordinator()
    converterCoordinator.converterViewController.tabBarItem = UITabBarItem(
      title: Constants.converterTitle,
      image: Constants.converterImage,
      selectedImage: Constants.converterSelectedImage
    )
    
    let accountsCoordinator = AccountsCoordinator()
    accountsCoordinator.accountsViewController.tabBarItem = UITabBarItem(
      title: Constants.accountsTitle,
      image: Constants.accountsImage,
      selectedImage: Constants.accountsSelectedImage
    )
    
    childCoordinators = [ratesCoordinator, converterCoordinator, accountsCoordinator]
    
    rootViewController.viewControllers = [
      ratesCoordinator.ratesViewController,
      converterCoordinator.converterViewController,
      accountsCoordinator.accountsViewController
    ]
  }
}
