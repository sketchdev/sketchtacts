//
//  EventsViewController.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: UIViewController {
    
    let events = ["Agile Indy", "Path to Agility", "Agile Midwest 2018"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new" {
            let navCtrl = segue.destination as! UINavigationController
            let ctrl = navCtrl.viewControllers.first as! NewEventViewController
            ctrl.setup(delegate: self)
        }
    }
    
}

extension EventsViewController: NewEventViewControllerDelegate {
    
    func onDone(_ viewController: NewEventViewController, wasCancelled: Bool, name: String?) {
        
    }
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)
        cell.textLabel?.text = events[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctrl = storyboard?.instantiateViewController(withIdentifier: "view") as! ViewEventViewController
        ctrl.title = events[indexPath.row]
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
}
