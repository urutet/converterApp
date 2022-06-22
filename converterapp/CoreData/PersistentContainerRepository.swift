//
//  AccountsPersistentContainer.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.06.22.
//

import Foundation
import CoreData

final class PersistentContainerRepository {
  private enum Constants {
    static let containerName = "Account"
  }
  
  static let shared = PersistentContainerRepository()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: Constants.containerName)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private init() { }
}
