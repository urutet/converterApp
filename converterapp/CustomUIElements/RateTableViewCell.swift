//
//  RateTableViewCell.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import UIKit

final class RateTableViewCell: UITableViewCell {

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
  }
  
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    
    return formatter
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    
    return stackView
  }()
  
  
  private let currencyFlagLabel: UILabel = {
    let label = UILabel()
    
    label.font = FontsManager.regular(ofSize: 50)
    label.textAlignment = .center
    
    return label
  }()
  
  private let currencyNameLabel: UILabel = {
    let label = UILabel()
    
    label.font = FontsManager.bold(ofSize: 30)
    label.textAlignment = .left
    
    return label
  }()
  
  private let currencyRateLabel: UILabel = {
    let label = UILabel()
    
    label.font = FontsManager.bold(ofSize: 30)
    label.textAlignment = .right
    
    return label
  }()
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    addSubviews()
    addConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    addSubviews()
    addConstraints()
  }
  
  // MARK: - API
  func setRate(currency: Currency) {
    currencyFlagLabel.text = currency.abbreviation?.flagFromCurrency()
    currencyNameLabel.text = currency.abbreviation
    numberFormatter.currencyCode = currency.abbreviation
    currencyRateLabel.text = numberFormatter.string(from: NSDecimalNumber(decimal: currency.rate ?? 0.0))
  }
  // MARK: - Setups
  private func setupUI() {
    contentView.backgroundColor = Constants.contentViewBackgroundColor
    contentView.layer.shadowOpacity = Constants.contentViewShadowOpacity
    contentView.layer.shadowColor = Constants.contentViewShadowColor
    contentView.layer.shadowOffset = Constants.contentViewShadowOffset
    contentView.layer.shadowRadius = Constants.contentViewShadowRadius
    contentView.layer.cornerRadius = Constants.contentViewCornerRadius
  }
  
  private func addSubviews() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(currencyFlagLabel)
    stackView.addArrangedSubview(currencyNameLabel)
    stackView.addArrangedSubview(currencyRateLabel)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  // MARK: - Helpers
}
