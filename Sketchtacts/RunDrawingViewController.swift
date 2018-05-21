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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var rerunButton: UIBarButtonItem!
    
    var _delegate: RunDrawingViewControllerDelegate!
    var _event: Event!
    var people: [Person] = []
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
    
    public func setup(delegate: RunDrawingViewControllerDelegate, event: Event) {
        _delegate = delegate
        _event = event
        people = _event.people?.allObjects as! [Person]
    }
    
    override func viewDidLoad() {
        chooseWinner()
        animateActivityIndicator()
    }
    
    @IBAction func onNext(_ sender: Any) {
        if people.count > 0 {
            people.remove(at: winnerIndex)
            winnerLabel.alpha = 0
            companyLabel.alpha = 0
            activityIndicator.alpha = 1
            chooseWinner()
            animateActivityIndicator()
            if people.count == 0 {
                rerunButton.isEnabled = false
            }
        }
    }
    
    func chooseWinner() {
        if people.count > 0 {
            winnerIndex = Int(arc4random_uniform(UInt32(people.count)))
            winner = people[winnerIndex]
        }
    }
    
    func updateWinnerLabel() {
        if winner != nil {
            winnerLabel.text = "\(winner.firstName ?? "") \(winner.lastName ?? "" )"
            winnerLabel.alpha = 1
            companyLabel.text = "\(winner.company ?? "")"
            companyLabel.alpha = 1
        }
    }
    
    func animateActivityIndicator() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 2, animations: {
            self.activityIndicator.alpha = 0.0
        }) { complete in
            self.activityIndicator.stopAnimating()
            self.updateWinnerLabel()
        }
    }
}
