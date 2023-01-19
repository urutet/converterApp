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
    guard let modelURL = Bundle(for: type(of: self)).url(forResource: Constants.containerName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
    }

    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Error initializing mom from: \(modelURL)")
    }
    
    let container = NSPersistentContainer(name: Constants.containerName, managedObjectModel: mom)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private init() { }
}
