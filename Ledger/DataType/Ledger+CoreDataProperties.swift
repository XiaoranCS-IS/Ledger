//
//  Ledger+CoreDataProperties.swift
//  
//
//  Created by 李笑然 on 2020/12/17.
//
//

import Foundation
import CoreData


extension Ledger {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ledger> {
        return NSFetchRequest<Ledger>(entityName: "Ledger")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var totalCost: Double
    @NSManaged public var totalEarn: Double
    @NSManaged public var type: String?
    @NSManaged public var id: String?
    @NSManaged public var recordData: NSSet?
    @NSManaged public var userList: NSSet?

}

// MARK: Generated accessors for recordData
extension Ledger {

    @objc(addRecordDataObject:)
    @NSManaged public func addToRecordData(_ value: Record)

    @objc(removeRecordDataObject:)
    @NSManaged public func removeFromRecordData(_ value: Record)

    @objc(addRecordData:)
    @NSManaged public func addToRecordData(_ values: NSSet)

    @objc(removeRecordData:)
    @NSManaged public func removeFromRecordData(_ values: NSSet)

}

// MARK: Generated accessors for userList
extension Ledger {

    @objc(addUserListObject:)
    @NSManaged public func addToUserList(_ value: User)

    @objc(removeUserListObject:)
    @NSManaged public func removeFromUserList(_ value: User)

    @objc(addUserList:)
    @NSManaged public func addToUserList(_ values: NSSet)

    @objc(removeUserList:)
    @NSManaged public func removeFromUserList(_ values: NSSet)

}
