//
//  MainCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit
import Swinject
import converterappCore

final class MainCoordinator: Coordinator, AppDependencyProvider {
  private enum Constants {
    static let ratesImage = UIImage(systemName: "dollarsign.circle")
    static let ratesSelectedImage = UIImage(systemName: "dollarsign.circle.fill")
    static let converterImage = UIImage(systemName: "repeat.circle")
    static let converterSelectedImage = UIImage(systemName: "repeat.circle.fill")
    static let accountsImage = UIImage(systemName: "person.crop.circle")
    static let accountsSelectedImage = UIImage(systemName: "person.crop.circle.fill")
  }
  
  var rootViewController: UITabBarController = {
    let tabBarController = UITabBarController()
    
    tabBarController.view.backgroundColor = .systemBackground
    
    return tabBarController
  }()
  
  var childCoordinators = [Coordinator]()
  let authStateService = MainCoordinator.container.resolve(AuthStateListener.self)
  
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
    
    let accountsCoordinator = AccountsCoordinator()
    let accountsViewModel = AccountsViewModel()
    accountsCoordinator.viewModel = accountsViewModel
    accountsCoordinator.start()
    accountsCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.accounts,
      image: Constants.accountsImage,
      selectedImage: Constants.accountsSelectedImage
    )
    accountsCoordinator.rootViewController.tabBarItem = UITabBarItem(
      title: Strings.Main.accounts,
      image: Constants.accountsImage,
      selectedImage: Constants.accountsSelectedImage
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
    
    childCoordinators = [ratesCoordinator, converterCoordinator, accountsCoordinator, authCoordinator]
    
    authStateService?.addAuthStateListener { [weak self] authState in
      self?.setViewControllers(authState: authState)
    }
  }
  
  func setViewControllers(authState: AuthState) {
    let viewControllersToPush: [UIViewController?] = childCoordinators.compactMap { coordinator -> UIViewController? in
      switch authState {
      case .loggedIn:
        if coordinator is AuthCoordinator { return nil }
        return coordinator.getRootViewController()
      case .notLoggedIn:
        if coordinator is AccountsCoordinator { return nil }
        return coordinator.getRootViewController()
      }
    }
    rootViewController.viewControllers = viewControllersToPush.compactMap { $0 }
  }
  
  func getRootViewController() -> UIViewController {
    rootViewController
  }
}
