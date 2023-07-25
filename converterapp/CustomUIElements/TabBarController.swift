//
//  UITabBarController+EyeTracking.swift
//  converterapp
//
//  Created by Ilya Yushkevich on 15.05.2023.
//

import UIKit
import EyeTracking

class TabBarController: UITabBarController, FaceTrackerDelegate, EyeTrackerDelegate {
  var manager: TrackingManager {
    TrackingManager.shared
  }
    
    var lastActionDate = Date()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeEyeTracking()
    super.viewWillDisappear(animated)
  }
  
  func setupEyeTracking() {
    manager.eyeTracker.setDelegate(self)
    manager.faceTracker.setDelegate(self)
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeLookOutLeft, minValue: 0.5, maxValue: 1))
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeLookOutRight, minValue: 0.5, maxValue: 1))
  }
  
  func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeLookOutLeft, minValue: 0.1, maxValue: 1))
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeLookOutRight, minValue: 0.1, maxValue: 1))
  }
  
  public func faceTracker(_ faceTracker: EyeTracking.FaceTracker, didUpdateExpression expression: EyeTracking.FaceExpression) {
      manager.eyeTracker.delegates.forEach { delegate in
          delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
      }
  }
  
  public func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
      guard
        let items = tabBar.items
      else { return }
      
      switch state {
      case .screenIn:
          return
          
      case .screenOut(let edge, _):
          guard Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 2.0 else { return }
          switch edge {
          case .left:
              guard selectedIndex - 1 >= 0 else { return }
              selectedIndex -= 1
          case .right:
              guard selectedIndex + 1 <= items.count else { return }
              selectedIndex += 1
          case .bottom, .top:
              return
          }
          lastActionDate = Date()
      }
  }
}
