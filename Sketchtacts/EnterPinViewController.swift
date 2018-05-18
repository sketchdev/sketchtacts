//
//  EnterPinViewController.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/17/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit

protocol EnterPinViewControllerDelegate {
    func onDone(_ viewController: EnterPinViewController, wasCancelled: Bool)
}

class EnterPinViewController: UITableViewController {
    
    @IBOutlet weak var pinTextField: UITextField!
    
    var _delegate: EnterPinViewControllerDelegate!
    
    @IBAction func onCancel(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if pinTextField.text == "1309" {
            dismiss(animated: true, completion: nil)
            _delegate.onDone(self, wasCancelled: false)
        } else {
            let alert = UIAlertController(title: "Error", message: "The PIN is invalid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func setup(delegate: EnterPinViewControllerDelegate) {
        _delegate = delegate
    }
}
