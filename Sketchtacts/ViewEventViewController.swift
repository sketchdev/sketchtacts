//
//  ViewEventViewController.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShowEventViewController: UIViewController {
    
    var _event: Event!
    var _context: NSManagedObjectContext!
    
    func setup(event: Event, context: NSManagedObjectContext) {
        _event = event
        _context = context
        title = event.name
    }
}
