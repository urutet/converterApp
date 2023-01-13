//
//  MainCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit
import Swinject

final class MainCoordinator: Coordinator {
  
  private enum Constants {
    static let ratesImage = UIImage(systemName: "dollarsign.circle")
    static let ratesSelectedImage = UIImage(systemName: "dollarsign.circle.fill")
    static let converterImage = UIImage(systemName: "repeat.circle")
    static let converterSelectedImage = UIImage(systemName: "repeat.circle.fill")
    static let accountsImage = UIImage(systemName: "person.crop.circle")
    static let accountsSelectedImage = UIImage(systemName: "person.crop.circle.fill")
  }
  
  let container = Container()
  let rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    
    tabBarController.view.backgroundColor = .systemBackground
    
    return tabBarController
  }()
  
  var childCoordinators = [Coordinator]()
  
  func start() {
    let ratesCoordinator = RatesCoordinator()
    let ratesViewModel = RatesViewModel()
    ratesCoordinator.viewModel = ratesViewModel
    ratesCoordinator.start()
    ratesCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.rates,
      image: Constants.ratesImage,
      selectedImage: Constants.ratesSelectedImage
    )
    
    let converterCoordinator = ConverterCoordinator()
    let converterViewModel = ConverterViewModel()
    converterCoordinator.viewModel = converterViewModel
    converterCoordinator.start()
    converterCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.converter,
      image: Constants.converterImage,
      selectedImage: Constants.converterSelectedImage
    )
    
    let authCoordinator = AuthCoordinator()
    let authViewModel = AuthViewModel()
    authCoordinator.parentCoordinator = self
    authCoordinator.viewModel = authViewModel
    authCoordinator.start()
    authCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.accounts,
      image: Constants.accountsImage,
      selectedImage: Constants.accountsSelectedImage
    )
    
    childCoordinators = [ratesCoordinator, converterCoordinator, authCoordinator]
    
    rootViewController.viewControllers = [
      ratesCoordinator.rootViewController,
      converterCoordinator.rootViewController,
      authCoordinator.rootViewController
    ]
  }
}
