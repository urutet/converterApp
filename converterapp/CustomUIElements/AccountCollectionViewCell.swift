//
//  AccountCollectionViewCell.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 27.04.22.
//

import UIKit
import converterappCore

class AccountCollectionViewCell: UICollectionViewCell {
  // MARK: - Properties
  // MARK: Public
  // MARK: Private
  private enum Constants {
    static let contentViewShadowOpacity: Float = 0.2
    static let contentViewShadowRadius: CGFloat = 5
    static let contentViewShadowOffset: CGSize = .zero
    static let contentViewCornerRadius: CGFloat = 10
    static let contentViewBackgroundColor: UIColor = .systemBackground
    static let contentViewShadowColor: CGColor = UIColor.black.cgColor
    static let currencyEmojiSize: CGFloat = 50
  }
  
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    
    label.textAlignment = .center
    
    return label
  }()
  private let currencyLabel: UILabel = {
    let label = UILabel()
    
    label.textAlignment = .center
    label.font = FontsManager.regular(ofSize: Constants.currencyEmojiSize)

    return label
  }()
  
  private let balanceLabel: UILabel = {
    let label = UILabel()
    
    label.textAlignment = .center
    
    return label
  }()
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  // MARK: - API
  func setAccount(_ account: Account) {
    nameLabel.text = account.name
    currencyLabel.text = account.currency.flagFromCurrency()
    numberFormatter.currencyCode = account.currency
    balanceLabel.text = numberFormatter.string(from: account.balance as NSDecimalNumber? ?? 0.0)
  }
  
  // MARK: - Setups
  private func setupUI() {
    contentView.backgroundColor = Constants.contentViewBackgroundColor
    contentView.layer.shadowOpacity = Constants.contentViewShadowOpacity
    contentView.layer.shadowColor = Constants.contentViewShadowColor
    contentView.layer.shadowOffset = Constants.contentViewShadowOffset
    contentView.layer.shadowRadius = Constants.contentViewShadowRadius
    contentView.layer.cornerRadius = Constants.contentViewCornerRadius
    
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(currencyLabel)
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(balanceLabel)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  // MARK: - Helpers
}
