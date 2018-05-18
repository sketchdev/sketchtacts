//
//  ConfirmViewController.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/16/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit

protocol ConfirmViewControllerDelegate {
    func onDone(_ viewController: ConfirmViewController)
}

class ConfirmViewController: UIViewController {
    
    var _delegate: ConfirmViewControllerDelegate!
    
    @IBAction func onDone(_ sender: Any) {
        _delegate.onDone(self)
        dismiss(animated: true, completion: nil)
    }
    
    public func setup(delegate: ConfirmViewControllerDelegate) {
        _delegate = delegate
    }
}
