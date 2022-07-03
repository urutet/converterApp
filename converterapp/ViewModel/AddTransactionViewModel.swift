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
  var transactionName = CurrentValueSubject<String?, Never>(nil)
  var transactionDate: Date? = nil
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

  
  func saveTransaction() {
    guard
      let name = transactionName.value,
      let date = transactionDate,
      let amount = transactionAmount.value,
      !name.isEmpty
    else { return }
    let transaction = Transaction(name: name, date: date, amount: amount)
    saveAction.send(transaction)
  }
}
