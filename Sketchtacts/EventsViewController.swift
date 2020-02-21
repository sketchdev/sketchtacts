//
//  EventsViewController.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResultsController: NSFetchedResultsController<Event>!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        try! fetchResultsController.performFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new" {
            let navCtrl = segue.destination as! UINavigationController
            let ctrl = navCtrl.viewControllers.first as! NewEventViewController
            ctrl.setup(delegate: self)
        } else if segue.identifier == "view" {
            let tableViewCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: tableViewCell)
            let event = fetchResultsController.object(at: indexPath!)
            let ctrl = segue.destination as! ShowEventViewController
            ctrl.setup(event: event, context: appDelegate.persistentContainer.viewContext)
        }
    }
    
}

extension EventsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension EventsViewController: NewEventViewControllerDelegate {
    func onDone(_ viewController: NewEventViewController, wasCancelled: Bool, name: String?, image: Data?) {
        if !wasCancelled {
            let context = appDelegate.persistentContainer.viewContext
            let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
            event.name = name
            event.image = image
            appDelegate.saveContext()
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)
        let event = fetchResultsController.object(at: indexPath) 
        cell.textLabel?.text = event.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, done) in
            let event = self.fetchResultsController.object(at: indexPath)
            self.appDelegate.persistentContainer.viewContext.delete(event)
            self.appDelegate.saveContext()
            done(true)
        }
        actions.append(delete)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ctrl = storyboard?.instantiateViewController(withIdentifier: "view") as! ViewEventViewController
//        ctrl.title = events[indexPath.row]
//        navigationController?.pushViewController(ctrl, animated: true)
//    }
    
}
