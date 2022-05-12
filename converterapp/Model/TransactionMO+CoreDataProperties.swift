//
//  TransactionMO+CoreDataProperties.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 12.05.22.
//
//

import Foundation
import CoreData


extension TransactionMO {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionMO> {
    return NSFetchRequest<TransactionMO>(entityName: "TransactionMO")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var date: Date?
  @NSManaged public var amount: NSDecimalNumber?
  
}

extension TransactionMO : Identifiable {
  
}
