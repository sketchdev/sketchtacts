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
    func onDone(_ viewController: NewEventViewController, wasCancelled: Bool, isNew: Bool, name: String?, image: Data?, newUserHeader: String?, userConfirmHeader: String?, userConfirmDescription: String?)
}

class NewEventViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var newUserHeaderTextField: UITextField!
    @IBOutlet var userConfirmHeaderTextField: UITextField!
    @IBOutlet var userConfirmDescriptionTextField: UITextField!
    var _image: Data?
    var _event: Event?
    
    let imagePicker = UIImagePickerController()
    var _delegate: NewEventViewControllerDelegate!
    
    override func viewDidAppear(_ animated: Bool) {
        if let event = _event {
            nameTextField.isEnabled = false
            nameTextField.text = event.name
            newUserHeaderTextField.text = event.newUserFormHeader
            userConfirmDescriptionTextField.text = event.confirmUserDescription
            userConfirmHeaderTextField.text = event.confirmUserHeader
            if event.image != nil {
                _image = event.image
                imageView.image = UIImage(data: event.image!)
            }
        }
    }
    
    @IBAction func onNameChange(_ sender: Any) {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func onSave(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: false, isNew: _event == nil, name: nameTextField.text, image: _image, newUserHeader: newUserHeaderTextField.text, userConfirmHeader: userConfirmHeaderTextField.text, userConfirmDescription: userConfirmDescriptionTextField.text)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: true, isNew: false, name: nil, image: nil, newUserHeader: nil, userConfirmHeader: nil, userConfirmDescription: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSelectImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    public func setup(delegate: NewEventViewControllerDelegate, event: Event?) {
        _delegate = delegate
        _event = event
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        _image = UIImagePNGRepresentation(image)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClear(_ sender: Any) {
        imageView.image = UIImage(named: "no-image-selected")
        _image = nil
    }
}
