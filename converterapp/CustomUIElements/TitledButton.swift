//
//  TitledButton.swift
//  converterapp
//
//  Created by user on 13.01.2023.
//

import UIKit

class TitledButton: UIButton {
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    
    return stackView
  }()
  
  private let leftDividerView: UIView = {
    let view = UIView()
    
    view.backgroundColor = .gray
    
    return view
  }()
  
  private let rightDividerView: UIView = {
    let view = UIView()
    
    view.backgroundColor = .gray
    
    return view
  }()
  
  private let label: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.semiBold(ofSize: 12)
    label.textColor = .gray
    label.textAlignment = .center

    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    addSubview(stackView)
    stackView.addArrangedSubview(leftDividerView)
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(rightDividerView)
    
    stackView.isHidden = true
    
    NSLayoutConstraint.activate([
      stackView.bottomAnchor.constraint(equalTo: topAnchor, constant: -5),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      leftDividerView.heightAnchor.constraint(equalToConstant: 1),
      rightDividerView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
  
  func setText(_ text: String) {
    label.text = text
    stackView.isHidden = text.isEmpty
  }
}
