//
//  RatesCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class RatesCoordinator: Coordinator {
  
  private let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var ratesViewController: RatesViewController = {
    let ratesViewController = RatesViewController()
    
    return ratesViewController
  }()
  
  func start() {
    rootViewController.setViewControllers([ratesViewController], animated: false)
  }
  
}
