//
//  AccountMO+CoreDataProperties.swift
//  converterapp
//
//  Created by Yushkevich Ilya on 6.06.22.
//
//

import Foundation
import CoreData


extension AccountMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountMO> {
        return NSFetchRequest<AccountMO>(entityName: "AccountMO")
    }

    @NSManaged public var balance: NSDecimalNumber?
    @NSManaged public var currency: String?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension AccountMO {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionMO)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionMO)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension AccountMO : Identifiable {

}
