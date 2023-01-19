//
//  FirebaseRemoteConfig.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 4.07.22.
//

import Foundation
import FirebaseRemoteConfig

public final class FirebaseRemoteConfig: RemoteConfigProtocol {
  private enum Constants {
    static let accountDeleteAlertEnabled = "accountDeleteAlertEnabled"
  }
  
  public static let shared = FirebaseRemoteConfig()
  private static let remoteConfig = RemoteConfig.remoteConfig()
  let defaults: [String : NSObject] = [
    Constants.accountDeleteAlertEnabled : false as NSObject
  ]
  
  public var boolParameters: [String : Bool] = [:]
  
  let settings: RemoteConfigSettings = {
    let settings = RemoteConfigSettings()
    
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    
    return settings
  }()
  
  public func fetchParameters() {
    FirebaseRemoteConfig.remoteConfig.setDefaults(defaults)
    FirebaseRemoteConfig.remoteConfig.fetch(withExpirationDuration: 0) { status, error in
      guard
        status == .success,
        error == nil
      else { return }
      
      FirebaseRemoteConfig.remoteConfig.activate { [weak self] _, error  in
        guard error == nil else { return }
        self?.boolParameters[Constants.accountDeleteAlertEnabled] = FirebaseRemoteConfig
          .remoteConfig.configValue(forKey: Constants.accountDeleteAlertEnabled).boolValue
      }
    }
    
  }
}
