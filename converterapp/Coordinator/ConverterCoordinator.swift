//
//  ConverterCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 26.04.22.
//

import UIKit

final class ConverterCoordinator: Coordinator {
  
  private let rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    return navigationController
  }()
  
  lazy var converterViewController: ConverterViewController = {
    let converterViewController = ConverterViewController()
    
    return converterViewController
  }()
  
  func start() {
    rootViewController.setViewControllers([converterViewController], animated: false)

  }
  
}
