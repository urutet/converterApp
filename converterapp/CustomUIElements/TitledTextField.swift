//
//  TitledTextField.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit
import EyeTracking

final class TitledTextField: UITextField {
  
  // MARK: - Properties
  // MARK: Public
  // MARK: Private
//    private var speechRecognizer = SpeechRecognizer()
//    private let manager = TrackingManager.shared
//    private var lastActionDate = Date()
  private let label: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.semiBold(ofSize: 15)
    
    return label
  }()
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTextField()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupTextField()
  }
    
//    deinit {
//        removeEyeTracking()
//    }
  
  // MARK: - API
  func setTitle(_ title: String) {
    label.text = title
  }
  // MARK: - Setups
  private func setupTextField() {
    addSubview(label)
//      setupEyeTracking()
//      addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
//      addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
      inputView = UIView()
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: topAnchor, constant: -5),
    ])
  }
    
//    private func setupEyeTracking() {
//        manager.eyeTracker.setDelegate(self)
//        manager.faceTracker.setDelegate(self)
//        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
//        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .tongueOut, minValue: 0.2, maxValue: 1))
//
//    }
    
//    private func removeEyeTracking() {
//        manager.eyeTracker.removeDelegate(self)
//        manager.faceTracker.removeDelegate(self)
//    }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
    
//    @objc
//    private func editingDidBegin() {
//        speechRecognizer.resetTranscript()
//        speechRecognizer.startTranscribing()
//    }
    
//    @objc
//    private func editingDidEnd() {
//        speechRecognizer.stopTranscribing()
//        text = speechRecognizer.transcript
//    }
}

//extension TitledTextField: EyeTrackerDelegate, FaceTrackerDelegate {
//    func faceTracker(_ faceTracker: EyeTracking.FaceTracker, didUpdateExpression expression: EyeTracking.FaceExpression) {
//        manager.eyeTracker.delegates.forEach { delegate in
//            delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
//        }
//    }
//
//    public func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
//        guard let expression else { return }
//        guard Date().timeIntervalSinceNow - lastActionDate.timeIntervalSinceNow >= 1.0 else { return }
//        switch state {
//        case .screenIn(let point):
//            switch expression.blendShape {
//            case .jawOpen:
//                print(frame)
//                print(point)
//                let newPoint = CGPoint(x: point.x, y: point.y - 145.0)
//                if frame.contains(newPoint) {
//                    backgroundColor = .red
//                    sendActions(for: .editingDidBegin)
//                }
//            case .tongueOut:
//                backgroundColor = .clear
//                sendActions(for: .editingDidEnd)
//            default:
//                return
//            }
//            lastActionDate = Date()
//        case .screenOut(let edge, _):
//            return
//        }
//    }
//}
