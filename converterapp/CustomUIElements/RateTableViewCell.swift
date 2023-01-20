//
//  RateTableViewCell.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import UIKit
import converterappCore

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
    static let currencyCode = "BYN"
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
    stackView.distribution = .fillEqually
    
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
    
    label.font = FontsManager.medium(ofSize: 20)
    label.textAlignment = .center
    
    return label
  }()
  
  private let currencyRateLabel: UILabel = {
    let label = UILabel()
    
    label.font = FontsManager.medium(ofSize: 20)
    label.textAlignment = .center
    
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
    currencyNameLabel.text = "\(currency.scale!) \(currency.abbreviation!)"
    numberFormatter.currencyCode = Constants.currencyCode
    currencyRateLabel.text = numberFormatter.string(from: NSDecimalNumber(decimal: currency.rate ?? 0.0))
  }
  // MARK: - Setups
  private func setupUI() {
    stackView.backgroundColor = Constants.contentViewBackgroundColor
    stackView.layer.shadowOpacity = Constants.contentViewShadowOpacity
    stackView.layer.shadowColor = Constants.contentViewShadowColor
    stackView.layer.shadowOffset = Constants.contentViewShadowOffset
    stackView.layer.shadowRadius = Constants.contentViewShadowRadius
    stackView.layer.cornerRadius = Constants.contentViewCornerRadius
  }
  
  private func addSubviews() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(currencyFlagLabel)
    stackView.addArrangedSubview(currencyNameLabel)
    stackView.addArrangedSubview(currencyRateLabel)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: 100),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  // MARK: - Helpers
}
