//
//  AccountDetailsViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 11.05.22.
//

import UIKit
import Combine
import EyeTracking

final class AccountDetailsViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: AccountDetailsViewModel!
  // MARK: Private
  private var subscriptions = Set<AnyCancellable>()
  private enum Constants {
    static let cellHeight: CGFloat = 100
    static let TransactionCellReuseIdentifier = "TransactionCell"
    static let accountDeleteAlertEnabled = "accountDeleteAlertEnabled"
  }
  
  private let manager = TrackingManager.shared
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: Constants.TransactionCellReuseIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  
  private let navigationTitleLabel: UILabel = {
    let label = UILabel()
    
    label.backgroundColor = .clear
    label.numberOfLines = 2
    label.font = FontsManager.bold(ofSize: 15)
    label.textAlignment = .center
    
    return label
  }()
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addTransaction)
    )
    setupSubscriptions()
    addSubviews()
    addConstraints()
    viewModel.getTransactions()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
    override func viewDidAppear(_ animated: Bool) {
      setupEyeTracking()
      super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      removeEyeTracking()
    }
    
    // MARK: - API
    // MARK: - Setups
    private func setupEyeTracking() {
      manager.eyeTracker.setDelegate(self)
      manager.faceTracker.setDelegate(self)
      manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.7, maxValue: 1))
        manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.3, maxValue: 1))

    }
    
    private func removeEyeTracking() {
      manager.eyeTracker.removeDelegate(self)
      manager.faceTracker.removeDelegate(self)
        manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.1, maxValue: 1))
          manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .mouthSmileLeft, minValue: 0.3, maxValue: 1))
    }
  private func setupUI() {
    self.navigationItem.titleView = navigationTitleLabel
    navigationTitleLabel.text = viewModel.account.name
    view.backgroundColor = .systemBackground
  }
  
  private func setupSubscriptions() {
    viewModel.$account
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.navigationTitleLabel.text = strongSelf.viewModel.account.name
        + "\n\(strongSelf.viewModel.account.transactions.count) "
        + Strings.AccountDetails.transactions
        strongSelf.tableView.reloadData()
      }
      .store(in: &subscriptions)
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  // MARK: - Helpers
  @objc
  private func addTransaction() {
    viewModel.addTransaciton()
  }
}

extension AccountDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.account.transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
        .dequeueReusableCell(withIdentifier: Constants.TransactionCellReuseIdentifier) as? TransactionTableViewCell
    else  { return UITableViewCell() }
    
    cell.setTransaction(account: viewModel.account, index: indexPath.row)
    
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    Constants.cellHeight
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let editAction = UIContextualAction(style: .normal, title: Strings.AccountDetails.edit) { _, _, _  in
      tableView.beginUpdates()
      self.viewModel.editTransaction(index: indexPath.row)
      tableView.endUpdates()
    }
    
    let deleteAction = UIContextualAction(style: .destructive, title: Strings.AccountDetails.delete) { _, _, _ in
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .fade)
      self.viewModel.deleteTransaction(index: indexPath.row)
      tableView.endUpdates()
    }
    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }
}

extension AccountDetailsViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
      switch expression.blendShape {
      case .eyeBlinkLeft:
        hitAdd(at: point)
      case .mouthSmileLeft:
          navigationController?.popViewController(animated: true)
      default:
        return
      }
    case .screenOut(let edge, _):
      switch edge {
      case .left, .right:
        return
      case .top:
        scrollTableView(-6)
      case .bottom:
        scrollTableView(6)

      }
    }
  }
  
  private func hitAdd(at point: CGPoint) {
      if navigationController?.visibleViewController != self {
          if CGRect(x: 0, y: 30, width: 100, height: 70).contains(point) {
              navigationController?.popViewController(animated: true)
              return
          }
      } else {
          addTransaction()
      }
  }
  
  private func scrollTableView(_ y: CGFloat) {
    var nextContentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + y)
    nextContentOffset.y = min(max(nextContentOffset.y, 0), tableView.contentSize.height - tableView.bounds.height)
    tableView.setContentOffset(nextContentOffset, animated: false)
  }
  
  public func faceTracker(_ faceTracker: FaceTracker, didUpdateExpression expression: FaceExpression) {
    manager.eyeTracker.delegates.forEach { delegate in
      delegate?.eyeTracking(manager.eyeTracker, didUpdateState: manager.eyeTracker.state, with: expression)
    }
  }
}
