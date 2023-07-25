//
//  SegmentedControl.swift
//  converterapp
//
//  Created by Ilya Yushkevich on 17.05.2023.
//

import UIKit
import EyeTracking

class SegmentedControl: UISegmentedControl {
    let manager = TrackingManager.shared
    var lastActionDate = Date()
    
    override init(items: [Any]?) {
        super.init(items: items)
        setupEyeTracking()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeEyeTracking()
    }
    
    private func setupEyeTracking() {
        manager.eyeTracker.setDelegate(self)
        manager.faceTracker.setDelegate(self)
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkRight, minValue: 0.5, maxValue: 1))
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.5, maxValue: 1))

    }
    
    private func removeEyeTracking() {
        manager.eyeTracker.removeDelegate(self)
        manager.faceTracker.removeDelegate(self)
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkRight, minValue: 0.5, maxValue: 1))
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.5, maxValue: 1))
    }
}

extension SegmentedControl: EyeTrackerDelegate, FaceTrackerDelegate {
    func faceTracker(_ faceTracker: EyeTracking.FaceTracker, didUpdateExpression expression: EyeTracking.FaceExpression) {
        manager.eyeTracker.delegates.forEach { delegate in
            delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
        }
    }
    
    public func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
        guard let expression else { return }
        guard Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 2.0 else { return }
        switch state {
        case .screenIn:
            switch expression.blendShape {
            case .eyeBlinkRight:
                guard selectedSegmentIndex - 1 >= 0 else { return }
                selectedSegmentIndex -= 1
            case .eyeBlinkLeft:
                guard selectedSegmentIndex + 1 < numberOfSegments else { return }
                selectedSegmentIndex += 1
            default:
                return
            }
            sendActions(for: .valueChanged)
            lastActionDate = Date()
        case .screenOut(let edge, _):
            return
        }
    }
}
