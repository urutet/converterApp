//
//  RatesCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class RatesCoordinator: Coordinator {
  
  var viewModel: RatesViewModel!
  let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var ratesViewController = RatesViewController()
  
  func start() {
    ratesViewController.viewModel = viewModel
    rootViewController.setViewControllers([ratesViewController], animated: false)
  }
  
}
