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
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var runDrawing: UIBarButtonItem!
    
    var _event: Event!
    var _context: NSManagedObjectContext!
    var fetchResultsController: NSFetchedResultsController<Person>!
    
    func setup(event: Event, context: NSManagedObjectContext) {
        _event = event
        _context = context
        title = event.name
    }
    
    @IBAction func onExport(_ sender: Any) {
        let fileName = "\(_event.name?.replacingOccurrences(of: " ", with: "") ?? "")_contacts.csv"
        print(documentsDirectory)
        let path = documentsDirectory.appendingPathComponent(fileName)
        var csvText = "First Name,Last Name,Email,Company,Training,Coaching,Development,Winner\n"
        for person in _event.people?.allObjects as! [Person] {
            let newLine = "\(person.firstName ?? ""),\(person.lastName ?? ""),\(person.email ?? ""),\(person.company ?? ""),\(person.training ? "YES" : "NO"),\(person.coaching ? "YES" : "NO"),\(person.development ? "YES" : "NO"),\(person.winFlag ? "WINNER" : "")\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
//        let activityViewController = UIActivityViewController(activityItems: [path as Any], applicationActivities: [])
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//        present(activityViewController, animated: true, completion: nil)
    }
    
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).last!
    }
    
    override func viewDidLoad() {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let entriesPredicate = NSPredicate(format: "event == %@", _event)
        fetchRequest.predicate = entriesPredicate
        let primarySortDescriptor = NSSortDescriptor(key: "winFlag", ascending: false)
        let secondarySortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: _context, sectionNameKeyPath: "winFlag", cacheName: nil)
        fetchResultsController.delegate = self
        try! fetchResultsController.performFetch()
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
}

extension ShowEventViewController: RunDrawingViewControllerDelegate {
    func onDone(_ viewController: RunDrawingViewController, wasCancelled: Bool, winner: Person?) {
        if !wasCancelled {
            winner?.winFlag = true
            try! _context.save()
        }
    }
}

extension ShowEventViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contactsTableView.reloadData()
    }
}

extension ShowEventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchResultsController.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchResultsController.sections![section].name == WinFlag.yes.rawValue {
            return "Winners"
        } else {
            return "Entries"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let count = fetchResultsController.sections![section].numberOfObjects
        return "\(count)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        let person = fetchResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(person.firstName ?? "") \(person.lastName ?? "") - \(person.company ?? "") - \(person.email ?? "")"
        cell.textLabel?.textColor = person.eligibleFlag ? UIColor.black : UIColor.lightGray;
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        let person = self.fetchResultsController.object(at: indexPath)
        if self.fetchResultsController.sections![indexPath.section].name == WinFlag.no.rawValue {
            let title = person.eligibleFlag ? "Ineligible" : "Eligible"
            let ignore = UIContextualAction(style: .normal, title: title) { [unowned self] (action, view, done) in
                person.eligibleFlag = !person.eligibleFlag
                //TODO:  UPDATE TRY WITH TRY CATCH
                try! self._context.save()
            }
            actions.append(ignore)
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, done) in
            if self.fetchResultsController.sections![indexPath.section].name == WinFlag.yes.rawValue {
                person.winFlag = false
            } else {
                self._context.delete(person)
            }
            //TODO:  UPDATE TRY WITH TRY CATCH
            try! self._context.save()
            done(true)
        }
        
        actions.append(delete)
        return UISwipeActionsConfiguration(actions: actions)
    }
}
enum MyError: Error {
    case runtimeError(String)
}

enum WinFlag: String {
    case yes = "1"
    case no = "0"
}
