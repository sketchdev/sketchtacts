//
//  Person+CoreDataProperties.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var company: String?
    @NSManaged public var event: Event?

}
