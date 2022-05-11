//
//  TransactionTableViewCell.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 11.05.22.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  // MARK: Public
  // MARK: Private
  private enum Constants {
    static let dateFormat = "dd.MM.yyyy"
    static let contentViewShadowOpacity: Float = 0.2
    static let contentViewShadowRadius: CGFloat = 5
    static let contentViewShadowOffset: CGSize = .zero
    static let contentViewCornerRadius: CGFloat = 10
    static let contentViewBackgroundColor: UIColor = .systemBackground
    static let contentViewShadowColor: CGColor = UIColor.black.cgColor
  }
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = Constants.dateFormat
    
    return dateFormatter
  }()
  
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
  
  private let nameDateStackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    
    return stackView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.bold(ofSize: 30)
    label.textAlignment = .left
    
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.regular(ofSize: 15)
    label.textAlignment = .left
    
    return label
  }()
  
  private let amountLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = FontsManager.medium(ofSize: 30)
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
  func setTransaction(account: Account, index: Int) {
    guard let transactions = account.transactions else { return }
    nameLabel.text = transactions[index].name
    dateLabel.text = dateFormatter.string(from: transactions[index].date)
    numberFormatter.currencyCode = account.currency
    amountLabel.text = numberFormatter.string(from: NSDecimalNumber(decimal: transactions[index].amount))
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
    stackView.addArrangedSubview(nameDateStackView)
    nameDateStackView.addArrangedSubview(nameLabel)
    nameDateStackView.addArrangedSubview(dateLabel)
    stackView.addArrangedSubview(amountLabel)
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
