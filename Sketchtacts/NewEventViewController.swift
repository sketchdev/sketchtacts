//
//  NewEventViewController.swift
//  Sketchtacts
//
//  Created by Cody Frederick on 5/15/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit

protocol NewEventViewControllerDelegate {
    func onDone(_ viewController: NewEventViewController, wasCancelled: Bool, name: String?)
}

class NewEventViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    
    var _delegate: NewEventViewControllerDelegate!
    
    @IBAction func onNameChange(_ sender: Any) {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func onSave(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: false, name: nameTextField.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: true, name: nil)
        dismiss(animated: true, completion: nil)
    }
    
    public func setup(delegate: NewEventViewControllerDelegate) {
        _delegate = delegate
    }
}
