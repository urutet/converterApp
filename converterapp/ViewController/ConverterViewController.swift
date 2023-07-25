//
//  ConverterViewController.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 25.04.22.
//

import UIKit
import Combine
import EyeTracking

final class ConverterViewController: UIViewController {
  
  // MARK: - Properties
  // MARK: Public
  var viewModel: ConverterViewModel!
  // MARK: Private
  private enum Constants {
    static let ConverterTableViewCellIdentifier = "ConverterTableViewCell"
    static let allowedCharacters = ".,0123456789"
  }
  
    private var selectedCell: ConverterTableViewCell?
    private let speechRecognizer = SpeechRecognizer()
  private var subscriptions = Set<AnyCancellable>()
  
  private let manager = TrackingManager.shared
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ConverterTableViewCell.self, forCellReuseIdentifier: Constants.ConverterTableViewCellIdentifier)
    tableView.separatorStyle = .none
    
    return tableView
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    addSubviews()
    addConstraints()
    setupSubscriptions()
    viewModel.getRates()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupEyeTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeEyeTracking()
  }
  
  // MARK: - Setups
  private func setupEyeTracking() {
    manager.eyeTracker.setDelegate(self)
    manager.faceTracker.setDelegate(self)
    manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
      manager.faceTracker.initiateFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.7, maxValue: 1))
  }
  
  private func removeEyeTracking() {
    manager.eyeTracker.removeDelegate(self)
    manager.faceTracker.removeDelegate(self)
    manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .jawOpen, minValue: 0.3, maxValue: 1))
      manager.faceTracker.removeFaceExpression(FaceExpression(blendShape: .eyeBlinkLeft, minValue: 0.7, maxValue: 1))
  }
  
  private func setupUI() {
    title = Strings.Converter.title
    view.backgroundColor = .systemBackground
  }
  
  private func setupSubscriptions() {
    viewModel.$converterCellViewModels
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.tableView.reloadData()
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
}

extension ConverterViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.converterCellViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView
        .dequeueReusableCell(withIdentifier: Constants.ConverterTableViewCellIdentifier) as? ConverterTableViewCell
    else { return UITableViewCell() }
    
    cell.viewModel = viewModel.converterCellViewModels[indexPath.row]
    cell.currencyAmountTextField.delegate = self
    
    cell.selectionStyle = .none
    
    return cell
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard
      let amount = Decimal(string: textField.text ?? "")
    else {
      let _ = viewModel.converterCellViewModels.map { $0.calculatedValue.send(nil) }
      return
    }
    
    let selectedCurrency = viewModel.converterCellViewModels
      .filter { $0.isSelected == true }
      .first?
      .currency
    
    viewModel.converterCellViewModels
      .filter { $0.isSelected == true }
      .first?
      .convertCurrency(amount: amount)
    
    let _ = viewModel.converterCellViewModels
      .filter { $0.isSelected == false }
      .map {
        $0.selectedCurrency = selectedCurrency
        $0.convertCurrency(amount: amount)
      }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
      guard
        let amount = Decimal(string: textField.text ?? "")
      else {
        let _ = viewModel.converterCellViewModels.map { $0.calculatedValue.send(nil) }
        return
      }
      
      let selectedCurrency = viewModel.converterCellViewModels
        .filter { $0.isSelected == true }
        .first?
        .currency
      
      viewModel.converterCellViewModels
        .filter { $0.isSelected == true }
        .first?
        .convertCurrency(amount: amount)
      
      let _ = viewModel.converterCellViewModels
        .filter { $0.isSelected == false }
        .map {
          $0.selectedCurrency = selectedCurrency
          $0.convertCurrency(amount: amount)
        }
    let _ = viewModel.converterCellViewModels.map { $0.isSelected = false }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if
      let textFieldIsEmpty = textField.text?.isEmpty,
      textFieldIsEmpty,
      string == "." || string == "," {
      return false
    }
    
    let allowedCharacters = CharacterSet(charactersIn: Constants.allowedCharacters)
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
}

extension ConverterViewController: EyeTrackerDelegate, FaceTrackerDelegate {
  func eyeTracking(_ eyeTracker: EyeTracking.EyeTracker, didUpdateState state: EyeTracking.EyeTracker.TrackingState, with expression: EyeTracking.FaceExpression?) {
    switch state {
    case .screenIn(let point):
      guard let expression else { return }
      switch expression.blendShape {
      case .jawOpen:
        hitCell(at: point)
      case .eyeBlinkLeft:
          print("Text \(speechRecognizer.transcript)")
          selectedCell?.currencyAmountTextField.text = speechRecognizer.transcript
          speechRecognizer.stopTranscribing()
          speechRecognizer.transcript = ""
          selectedCell?.isSelected = false
          selectedCell?.viewModel.isSelected = false
          selectedCell = nil
          view.endEditing(true)
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
  
  private func hitCell(at point: CGPoint) {
    if navigationController?.visibleViewController != self {
      if CGRect(x: 0, y: 30, width: 100, height: 70).contains(point) {
        navigationController?.popViewController(animated: true)
        return
      }
    } else {
      if
        let indexPath = tableView.indexPathForRow(at: view.convert(point, to: tableView)),
        let cell = tableView.cellForRow(at: indexPath) as? ConverterTableViewCell {
          speechRecognizer.startTranscribing()
          selectedCell = cell
          selectedCell?.viewModel.isSelected = true
        selectedCell?.currencyAmountTextField.becomeFirstResponder()
        return
      }
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
