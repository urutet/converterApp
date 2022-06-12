//
//  TransactionMO+CoreDataProperties.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 6.06.22.
//
//

import Foundation
import CoreData


extension TransactionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionMO> {
        return NSFetchRequest<TransactionMO>(entityName: "TransactionMO")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var account: AccountMO?

}

extension TransactionMO : Identifiable {

}
