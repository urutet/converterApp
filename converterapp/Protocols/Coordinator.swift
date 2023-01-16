//
//  Coordinator.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit

protocol Coordinator {
  func start()
  func getRootViewController() -> UIViewController
}
