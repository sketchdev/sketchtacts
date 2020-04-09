//
//  Event+CoreDataProperties.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/18/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var name: String?
    @NSManaged public var hasWinner: Bool
    @NSManaged public var people: NSSet?
    @NSManaged public var image: Data?
    @NSManaged public var newUserFormHeader: String?
    @NSManaged public var confirmUserHeader: String?
    @NSManaged public var confirmUserDescription: String?

}

// MARK: Generated accessors for people
extension Event {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: Person)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: Person)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}
