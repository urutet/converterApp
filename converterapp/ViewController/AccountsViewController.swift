//
//  AccountsViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import Combine

final class AccountsViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AccountsViewModel!
  // MARK: Private
  private enum Constants {
    static let accountCellIdentifier = "AccountCell"
    static let addAccountButtonColor: UIColor = .systemBlue
    static let addAccountButtonFontSize: CGFloat = 15
    static let removeAccount = UIImage(systemName: "trash")
    static let accountDeleteAlertEnabled = "accountDeleteAlertEnabled"
  }
  
  private var subscriptions = Set<AnyCancellable>()
  private var accounts = [Account]()
  
  private let accountsCollectionView: UICollectionView = {
    let layout = configureLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView.register(
      AccountCollectionViewCell.self,
      forCellWithReuseIdentifier: Constants.accountCellIdentifier
    )
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  private let addAccountButton: UIButton = {
    let button = UIButton()
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(Strings.Accounts.addAccount, for: .normal)
    button.titleLabel?.font = FontsManager.medium(ofSize: Constants.addAccountButtonFontSize)
    button.setTitleColor(Constants.addAccountButtonColor, for: .normal)
    
    button.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
    
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupSubscriptions()
    
    accountsCollectionView.delegate = self
    accountsCollectionView.dataSource = self
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addAccount)
    )
    
    addSubviews()
    addConstraints()
    
    viewModel.getAccounts()
  }
  
  // MARK: - API
  // MARK: - Setups
  private func setupUI() {
    view.backgroundColor = .systemBackground
  }
  
  private func addSubviews() {
    view.addSubview(accountsCollectionView)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      accountsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
      accountsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      accountsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      accountsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupSubscriptions() {
    viewModel.$accounts
      .receive(on: DispatchQueue.main)
      .sink { [weak self] accounts in
      guard let strongSelf = self else { return }
      if accounts.isEmpty {
        strongSelf.accountsCollectionView.backgroundView = strongSelf.addAccountButton
      } else {
        strongSelf.accountsCollectionView.backgroundView = nil
      }
      strongSelf.accountsCollectionView.reloadData()
    }
    .store(in: &subscriptions)
  }
  
  private static func configureLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  // MARK: - Helpers
  @objc
  private func addAccount() {
    viewModel.addAccount()
  }
  
  private func showAccountDetails(index: Int) {
    viewModel.showAccountDetails(index: index)
  }
  
  private func editAccount(index: Int) {
    viewModel.editAccount(index: index)
  }
  
  private func showConfirmationAlert(_ show: Bool, index: Int) {
    guard show else {
      viewModel.deleteAccount(index: index)
      return
    }
    
    let alertController = UIAlertController(
      title: Strings.Accounts.removeAccount,
      message: Strings.Accounts.deleteText,
      preferredStyle: .alert
    )
    
    let deleteAction = UIAlertAction(
      title: Strings.Accounts.removeAccount,
      style: .destructive
    ) { [weak self] _ in
      self?.viewModel.deleteAccount(index: index)
    }
    
    let cancelAction = UIAlertAction(title: Strings.Accounts.cancel, style: .cancel)
    
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    present(alertController, animated: true)
  }
}

extension AccountsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.accounts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = accountsCollectionView.dequeueReusableCell(
      withReuseIdentifier: Constants.accountCellIdentifier,
      for: indexPath
    ) as? AccountCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.setAccount(viewModel.accounts[indexPath.row])
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
      let showAccountAction = UIAction(
        title: Strings.Accounts.showAccount,
        state: .off) { [weak self] _ in
          self?.showAccountDetails(index: contextMenuConfigurationForItemAt.row)
        }
      
      let editAccountAction = UIAction(
        title: Strings.Accounts.editAccount,
        state: .off) { [weak self] _ in
          self?.editAccount(index: contextMenuConfigurationForItemAt.row)
        }
      
      let removeAccountAction = UIAction(
        title: Strings.Accounts.removeAccount,
        image: Constants.removeAccount,
        attributes: .destructive,
        state: .off) { [weak self] _ in
          guard
            let strongSelf = self,
            let isAccountDeleteAlertEnabled = strongSelf.viewModel
              .remoteConfig.boolParameters[Constants.accountDeleteAlertEnabled]
          else { return }
          
          print(isAccountDeleteAlertEnabled)
          strongSelf.showConfirmationAlert(
            isAccountDeleteAlertEnabled,
            index: contextMenuConfigurationForItemAt.row
          )
        }
      
      return UIMenu(
        title: Strings.Accounts.contextMenuTitle,
        options: .displayInline,
        children: [showAccountAction, editAccountAction, removeAccountAction]
      )
    }
    
    return configuration
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    showAccountDetails(index: indexPath.row)
  }
}
