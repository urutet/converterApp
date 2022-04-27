//
//  AppCoordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit

final class AppCoordinator: Coordinator {

  let window: UIWindow
  
  var childCoordinators = [Coordinator]()
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    let mainCoordinator = MainCoordinator()
    mainCoordinator.start()
    childCoordinators = [mainCoordinator]
    window.rootViewController = mainCoordinator.rootViewController
  }
}
