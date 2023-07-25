//
//  AppDelegate.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import FirebaseCore
import FirebaseInstallations
import Swinject
import converterappCore

import EyeTracking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let dependencyProvider = DependencyProvider()
  let session = Session()
    let keychainService = KeychainService()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      keychainService.save("111111", service: "Firebase", account: "default@mail.ru")
      UserDefaults.standard.set("default@mail.ru", forKey: "latestEmail")
    FirebaseApp.configure()
    
    FirebaseRemoteConfig.shared.fetchParameters()
    
    do {
      try session.start()
    } catch let error {
      print(error)
    }
    
    TrackingManager.shared.start(with: session)
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    do {
      try session.end()
    } catch let error {
      print(error)
    }
  }


}

