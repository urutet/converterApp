//
//  RateTableViewCell.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//

import UIKit
import Combine

final class ConverterTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: ConverterCellViewModel! {
    didSet {
      subscriptions = Set<AnyCancellable>()
      setupSubscriptions()
    }
  }
  // MARK: Private
  private enum Constants {
    static let contentViewShadowOpacity: Float = 0.2
    static let contentViewShadowRadius: CGFloat = 5
    static let contentViewShadowOffset: CGSize = .zero
    static let contentViewCornerRadius: CGFloat = 10
    static let contentViewBackgroundColor: UIColor = .systemBackground
    static let contentViewShadowColor: CGColor = UIColor.black.cgColor
    static let currencyFormat = "%.3f"
    static let currencyTextLabelPlaceholder = "0"
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 3
    return formatter
  }()
  
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .none
    formatter.maximumFractionDigits = 3
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
    
    label.font = FontsManager.bold(ofSize: 20)
    label.textAlignment = .center
    
    return label
  }()
  
  let currencyAmountTextField: UITextField = {
    let textField = UITextField()
    
    textField.font = FontsManager.medium(ofSize: 25)
    textField.textAlignment = .right
    textField.keyboardType = .decimalPad
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    let doneButton = UIBarButtonItem(
      title: Strings.AddAccounts.done,
      style: .plain,
      target: self,
      action: #selector(doneTapped)
    )
    let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.setItems([spacing, doneButton], animated: true)
    textField.inputAccessoryView = toolbar
    
    textField.placeholder = Constants.currencyTextLabelPlaceholder
    
    return textField
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
  
  func setupSubscriptions() {
    viewModel.$currency
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.currencyFlagLabel.text = strongSelf.viewModel.currency.abbreviation?.flagFromCurrency()
        strongSelf.currencyNameLabel.text = strongSelf.viewModel.currency.abbreviation
        strongSelf.currencyFormatter.currencyCode = strongSelf.viewModel.currency.abbreviation

        strongSelf.currencyRateLabel.text = strongSelf.currencyFormatter.currencySymbol
      }
      .store(in: &subscriptions)
    
    viewModel.calculatedValue
      .receive(on: DispatchQueue.main)
      .sink { [weak self] calculatedValue in
        self?.currencyAmountTextField.text = self?.numberFormatter.string(for: calculatedValue)
      }
      .store(in: &subscriptions)
  }
  
  
  // MARK: - Setups
  private func setupUI() {
    stackView.backgroundColor = Constants.contentViewBackgroundColor
    stackView.layer.shadowOpacity = Constants.contentViewShadowOpacity
    stackView.layer.shadowColor = Constants.contentViewShadowColor
    stackView.layer.shadowOffset = Constants.contentViewShadowOffset
    stackView.layer.shadowRadius = Constants.contentViewShadowRadius
    stackView.layer.cornerRadius = Constants.contentViewCornerRadius
    
    currencyAmountTextField.addTarget(self, action: #selector(textFieldIsEditing), for: .editingDidBegin)
  }
  
  private func addSubviews() {
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(currencyFlagLabel)
    stackView.addArrangedSubview(currencyNameLabel)
    stackView.addArrangedSubview(currencyAmountTextField)
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
  @objc
  private func doneTapped() {
    currencyAmountTextField.resignFirstResponder()
  }
  
  @objc
  private func textFieldIsEditing() {
    currencyAmountTextField.text = ""
    viewModel.isSelected = true
  }
}
