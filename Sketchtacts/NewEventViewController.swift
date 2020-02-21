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
    func onDone(_ viewController: NewEventViewController, wasCancelled: Bool, name: String?, image: Data?)
}

class NewEventViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    var _image: Data?
    
    let imagePicker = UIImagePickerController()
    var _delegate: NewEventViewControllerDelegate!
    
    @IBAction func onNameChange(_ sender: Any) {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func onSave(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: false, name: nameTextField.text, image: _image)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: true, name: nil, image: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSelectImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    public func setup(delegate: NewEventViewControllerDelegate) {
        _delegate = delegate
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
