//
//  User+CoreDataProperties.swift
//  
//
//  Created by 李笑然 on 2020/12/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var attendRecordList: NSSet?
    @NSManaged public var ledgerData: NSSet?

}

// MARK: Generated accessors for attendRecordList
extension User {

    @objc(addAttendRecordListObject:)
    @NSManaged public func addToAttendRecordList(_ value: Record)

    @objc(removeAttendRecordListObject:)
    @NSManaged public func removeFromAttendRecordList(_ value: Record)

    @objc(addAttendRecordList:)
    @NSManaged public func addToAttendRecordList(_ values: NSSet)

    @objc(removeAttendRecordList:)
    @NSManaged public func removeFromAttendRecordList(_ values: NSSet)

}

// MARK: Generated accessors for ledgerData
extension User {

    @objc(addLedgerDataObject:)
    @NSManaged public func addToLedgerData(_ value: Ledger)

    @objc(removeLedgerDataObject:)
    @NSManaged public func removeFromLedgerData(_ value: Ledger)

    @objc(addLedgerData:)
    @NSManaged public func addToLedgerData(_ values: NSSet)

    @objc(removeLedgerData:)
    @NSManaged public func removeFromLedgerData(_ values: NSSet)

}
