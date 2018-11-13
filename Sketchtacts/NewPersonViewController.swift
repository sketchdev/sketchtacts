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

class NewPersonViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    var _context: NSManagedObjectContext!
    var _event: Event!

    @IBAction func onChange(_ sender: UIButton) {
        updateButtonState()
    }
    
    public func setup(context: NSManagedObjectContext, event: Event) {
        _context = context
        _event = event
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstNameTextField.becomeFirstResponder()
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
        saveButton.backgroundColor = saveButton.isEnabled ? UIColor(named: "Secondary") : UIColor.darkGray
    }
    
    @IBAction func onClear(_ sender: Any) {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        companyTextField.text = ""
        firstNameTextField.becomeFirstResponder()
        updateButtonState()
    }
    
}

extension NewPersonViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == firstNameTextField) {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if (textField == lastNameTextField) {
            lastNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if (textField == emailTextField) {
            emailTextField.resignFirstResponder()
            companyTextField.becomeFirstResponder()
        } else {
            companyTextField.resignFirstResponder()
            performSegue(withIdentifier: "confirm", sender: self)
        }
        return true
    }
    
}
