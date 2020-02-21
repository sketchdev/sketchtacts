//
//  Person+CoreDataProperties.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/18/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var winFlag: Bool
    @NSManaged public var eligibleFlag: Bool
    @NSManaged public var event: Event?
    @NSManaged public var training: Bool
    @NSManaged public var coaching: Bool
    @NSManaged public var development: Bool

}
