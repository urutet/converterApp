//
//  TitledTextField.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import UIKit

final class TitledTextField: UITextField {
  
  // MARK: - Properties
  // MARK: Public
  // MARK: Private
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
  
  // MARK: - API
  func setTitle(_ title: String) {
    label.text = title
  }
  // MARK: - Setups
  private func setupTextField() {
    addSubview(label)
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: topAnchor, constant: -5)
    ])
  }
  // MARK: - Helpers
  
}
