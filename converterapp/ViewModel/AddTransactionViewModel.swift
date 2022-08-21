//
//  AddAccountViewModel.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 10.05.22.
//

import Combine
import Foundation

final class AddTransactionViewModel {
  var coordinator: AddTransactionCoordinator!
  var controllerType: ControllerInputType!
  
  var transactionID: UUID!
  var transactionName = CurrentValueSubject<String?, Never>(nil)
  var transactionDate = CurrentValueSubject<Date?, Never>(nil)
  var transactionAmount = CurrentValueSubject<Decimal?, Never>(nil)
  let saveAction = PassthroughSubject<Transaction, Never>()
  
  var isNameValidPublisher: AnyPublisher<Bool, Never> {
    transactionName.map { !($0 ?? "").isEmpty }
    .replaceNil(with: false)
    .dropFirst()
    .eraseToAnyPublisher()
  }
  
  var isTransactionAmountValidPublisher: AnyPublisher<Bool, Never> {
    transactionAmount.map { $0 != 0 }
    .replaceNil(with: false)
    .eraseToAnyPublisher()
  }

  func setTransaction(transaction: Transaction) {
    transactionID = transaction.id
    transactionName.send(transaction.name)
    transactionDate.send(transaction.date)
    transactionAmount.send(transaction.amount)
  }
  
  func saveTransaction() {
    guard
      let name = transactionName.value,
      let date = transactionDate.value,
      let amount = transactionAmount.value,
      !name.isEmpty
    else { return }
    var transaction: Transaction
    switch(controllerType) {
    case .add:
      transaction = Transaction(name: name, date: date, amount: amount)
    case .edit:
      transaction = Transaction(id: transactionID, name: name, date: date, amount: amount)
    case .none:
      return
    }
    saveAction.send(transaction)
  }
}
