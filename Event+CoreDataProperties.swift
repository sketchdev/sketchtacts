//
//  Event+CoreDataProperties.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
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
    @NSManaged public var people: Person?

}
