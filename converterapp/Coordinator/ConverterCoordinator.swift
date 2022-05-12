//
//  ConverterCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class ConverterCoordinator: Coordinator {
  
  let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var converterViewController: ConverterViewController = ConverterViewController()
  weak var viewModel: ConverterViewModel!
  
  func start() {
    converterViewController.viewModel = viewModel
    rootViewController.setViewControllers([converterViewController], animated: false)

  }
  
}
