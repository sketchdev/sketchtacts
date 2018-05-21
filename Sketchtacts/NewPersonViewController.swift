//
//  NewContactViewController.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/16/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//
//protocol NewContactViewControllerDelegate {
//    func onDone(_ viewController: NewContactViewController, wasCancelled: Bool, firstName: String?,
//                lastName: String?, email: String?, company: String?)
//}

extension NewPersonViewController: ConfirmViewControllerDelegate {
    func onDone(_ viewController: ConfirmViewController) {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        companyTextField.text = ""
        updateButtonState()
    }
}

extension NewPersonViewController: EnterPinViewControllerDelegate {
    func onDone(_ viewController: EnterPinViewController, wasCancelled: Bool) {
        if !wasCancelled {
            dismiss(animated: true, completion: nil)
        }
    }
}

class NewPersonViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    
    var _context: NSManagedObjectContext!
    var _event: Event!

    @IBAction func onChange(_ sender: UIButton) {
        updateButtonState()
    }
    
    public func setup(context: NSManagedObjectContext, event: Event) {
        _context = context
        _event = event
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirm" {

            let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: _context) as! Person
            person.firstName = firstNameTextField.text
            person.lastName = lastNameTextField.text
            person.email = emailTextField.text
            person.company = companyTextField.text
            person.event = _event
            
            try! _context.save()
            let ctrl = segue.destination as! ConfirmViewController
            ctrl.setup(delegate: self)
        } else if segue.identifier == "cancel" {
            let navCtrl = segue.destination as! UINavigationController
            let ctrl = navCtrl.viewControllers.first as! EnterPinViewController
            ctrl.setup(delegate: self)
        }
    }
    
    func updateButtonState() {
        saveButton.isEnabled =  !(firstNameTextField.text?.isEmpty)! && !(lastNameTextField.text?.isEmpty)! && !(emailTextField.text?.isEmpty)! && !(companyTextField.text?.isEmpty)!
    }
}
