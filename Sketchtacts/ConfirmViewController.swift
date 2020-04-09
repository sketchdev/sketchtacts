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
    func onDone(_ viewController: ConfirmViewController, training: Bool, coaching: Bool, development: Bool)
}

class ConfirmViewController: UIViewController {
    
    var _delegate: ConfirmViewControllerDelegate!
    @IBOutlet var trainingSwitch: UISwitch!
    @IBOutlet var coachingSwitch: UISwitch!
    @IBOutlet var developmentSwitch: UISwitch!
    @IBOutlet var trainingStack: UIStackView!
    @IBOutlet var coachingStack: UIStackView!
    @IBOutlet var developmentStack: UIStackView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var _training = false
    var _coaching = false
    var _development = false
    var _header: String?
    var _description: String?
    
    override func viewDidLoad() {
        headerLabel.text = _header ?? "You're In!"
        descriptionLabel.text = _description ?? "I'm sure you'll win, but you'll have to wait until later to find out."
        trainingSwitch.layer.cornerRadius = 16
        coachingSwitch.layer.cornerRadius = 16
        developmentSwitch.layer.cornerRadius = 16
        let trainingGuesture = UITapGestureRecognizer(target: self, action: #selector(self.setTrainingSwitch))
        trainingStack.addGestureRecognizer(trainingGuesture)
        let cocahingGuesture = UITapGestureRecognizer(target: self, action: #selector(self.setCoachingSwitch))
        coachingStack.addGestureRecognizer(cocahingGuesture)
        let developmentGuesture = UITapGestureRecognizer(target: self, action: #selector(self.setDevelopmentSwitch))
        developmentStack.addGestureRecognizer(developmentGuesture)
    }
    
    @objc func setTrainingSwitch(sender: AnyObject){
        trainingSwitch.isOn = !trainingSwitch.isOn
    }
    
    @objc func setCoachingSwitch(sender: AnyObject){
        coachingSwitch.isOn = !coachingSwitch.isOn
    }
    
    @objc func setDevelopmentSwitch(sender: AnyObject){
        developmentSwitch.isOn = !developmentSwitch.isOn
    }
    
    @IBAction func onDone(_ sender: Any) {
        _delegate.onDone(self, training: trainingSwitch.isOn, coaching: coachingSwitch.isOn, development: developmentSwitch.isOn)
        dismiss(animated: true, completion: nil)
    }
    
    public func setup(delegate: ConfirmViewControllerDelegate, header: String?, description: String?) {
        _delegate = delegate
        _header = header
        _description = description
    }
}
