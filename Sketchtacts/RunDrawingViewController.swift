//
//  ConfirmViewController.swift
//  Sketchtacts
//
//  Created by Heather Davis on 5/16/18.
//  Copyright © 2018 Cody Frederick. All rights reserved.
//

import Foundation
import UIKit

protocol RunDrawingViewControllerDelegate {
    func onDone(_ viewController: RunDrawingViewController, wasCancelled: Bool, winner: Person?)
}

class RunDrawingViewController: UIViewController {
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var rerunButton: UIBarButtonItem!
    
    var _delegate: RunDrawingViewControllerDelegate!
    var _event: Event!
    var _timer: Timer!
    var people: [Person] = []
    var displayPeople: [Person] = []
    var winner: Person!
    var winnerIndex: Int = 0
    
    @IBAction func onCancel(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: true, winner: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        _delegate.onDone(self, wasCancelled: false, winner: winner)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickWinner(_ sender: UITapGestureRecognizer) {
        if canRunDrawing() {
            winnerIndex = Int(arc4random_uniform(UInt32(people.count)))
            winner = people[winnerIndex]
            winnerLabel.textColor = UIColor(named: "Primary")
            winnerLabel.text = "\(winner.firstName ?? "") \(winner.lastName ?? "" )"
            companyLabel.text = "\(winner.company ?? "")"
            winnerLabel.isUserInteractionEnabled = false
        }
        _timer.invalidate()
    }
    
    public func setup(delegate: RunDrawingViewControllerDelegate, event: Event) {
        _delegate = delegate
        _event = event
        displayPeople = _event.people?.allObjects.filter { ($0 as! Person).winFlag == false } as! [Person]
        people = _event.people?.allObjects.filter { ($0 as! Person).winFlag == false && ($0 as! Person).eligibleFlag == true } as! [Person]
        _timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RunDrawingViewController.randomLabel), userInfo: nil, repeats: true);
    }
    
    override func viewDidLoad() {
        _timer.fire()
    }
    
    @IBAction func onNext(_ sender: Any) {
        if canRunDrawing() {
            winnerLabel.isUserInteractionEnabled = true
            companyLabel.text = ""
            people.remove(at: winnerIndex)
            if people.count == 0 {
                rerunButton.isEnabled = false
            }
            _timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(RunDrawingViewController.randomLabel), userInfo: nil, repeats: true);
        }
    }
    
    @objc func randomLabel() {
        if canRunDrawing() {
            let personIndex = Int(arc4random_uniform(UInt32(self.displayPeople.count)))
            let person = self.displayPeople[personIndex]
            self.winnerLabel.text = "\(person.firstName ?? "") \(person.lastName ?? "" )"
            self.winnerLabel.textColor = UIColor.random()
        }
    }
    
    func canRunDrawing() -> Bool {
        return people.count > 0
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
