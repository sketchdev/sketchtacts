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
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var _event: Event!
    var _context: NSManagedObjectContext!
    var _winner: Person!
    var fetchResultsController: NSFetchedResultsController<Person>!
    
    func setup(event: Event, context: NSManagedObjectContext) {
        _event = event
        _context = context
        title = event.name
    }
    
    @IBAction func onExport(_ sender: Any) {
        let fileName = "\(_event.name!)_contacts.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "First Name,Last Name,Email,Company,Winner\n"
        for person in _event.people?.allObjects as! [Person] {
            let newLine = "\(person.firstName ?? ""),\(person.lastName ?? ""),\(person.email ?? ""),\(person.company ?? ""),\(person.winFlag ? "WINNER" : "")\n"
            csvText.append(newLine)
        }
        
        print(path as Any)
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        let activityViewController = UIActivityViewController(activityItems: [path as Any], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let predicate = NSPredicate(format: "event == %@", _event)
        fetchRequest.predicate = predicate
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "firstName", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: _context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        try! fetchResultsController.performFetch()
        
        if _event.hasWinner {
            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            let predicate = NSPredicate(format: "event == %@ && winFlag == true", _event)
            fetchRequest.predicate = predicate
            let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "firstName", ascending: true)]
            fetchRequest.sortDescriptors = sortDescriptors
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: _context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            try! fetchResultsController.performFetch()
            _winner = fetchResultsController.fetchedObjects?.first
            updateWinnerLabel()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new" {
            let navCtrl = segue.destination as! UINavigationController
            let ctrl = navCtrl.viewControllers.first as! NewPersonViewController
            ctrl.setup(context: _context, event: _event)
        } else if segue.identifier == "runDrawing" {
            let navCtrl = segue.destination as! UINavigationController
            let ctrl = navCtrl.viewControllers.first as! RunDrawingViewController
            ctrl.setup(delegate: self, event: _event)
        }
    }
    
    func updateWinnerLabel() {
        if _event.hasWinner && _winner != nil {
            winnerLabel.text = "\(_winner.firstName ?? "") \(_winner.lastName ?? "") - \(_winner.company ?? "")"
        }
    }
}

extension ShowEventViewController: RunDrawingViewControllerDelegate {
    func onDone(_ viewController: RunDrawingViewController, wasCancelled: Bool, winner: Person?) {
        if !wasCancelled {
            if _event.hasWinner {
                
            }
            _event.hasWinner = true
            _winner = winner
            winner?.winFlag = true
            try! _context.save()
        }
    }
}

extension ShowEventViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        updateWinnerLabel()
    }
}

extension ShowEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        let person = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(person.firstName ?? "") \(person.lastName ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, done) in
            let person = self.fetchResultsController.object(at: indexPath)
            self._context.delete(person)
            try! self._context.save()
            done(true)
        }
        actions.append(delete)
        return UISwipeActionsConfiguration(actions: actions)
    }
}
