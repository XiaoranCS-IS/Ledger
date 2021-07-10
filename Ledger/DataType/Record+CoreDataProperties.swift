//
//  Record+CoreDataProperties.swift
//  
//
//  Created by 李笑然 on 2020/12/17.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var cost: Double
    @NSManaged public var earn: Double
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var attendUserList: NSSet?
    @NSManaged public var ledger: Ledger?

}

// MARK: Generated accessors for attendUserList
extension Record {

    @objc(addAttendUserListObject:)
    @NSManaged public func addToAttendUserList(_ value: User)

    @objc(removeAttendUserListObject:)
    @NSManaged public func removeFromAttendUserList(_ value: User)

    @objc(addAttendUserList:)
    @NSManaged public func addToAttendUserList(_ values: NSSet)

    @objc(removeAttendUserList:)
    @NSManaged public func removeFromAttendUserList(_ values: NSSet)

}
