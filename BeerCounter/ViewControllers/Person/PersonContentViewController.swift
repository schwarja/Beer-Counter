//
//  PersonContentViewController.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PersonContentViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var subtractButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var person: Person? {
        didSet {
            if isViewLoaded {
                setupUI()
            }
        }
    }
    
    var canResetCounter: Bool = false {
        didSet {
            if isViewLoaded {
                setupUI()
            }
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            if isViewLoaded {
                setupUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction func addBeer(_ sender: Any) {
        if let person = person {
            addBeer(toPerson: person, sender: self)
        }
    }
    
    @IBAction func subtractBeer(_ sender: Any) {
        if let person = person {
            subtractBeer(forPerson: person, sender: self)
        }
    }
    
    @IBAction func resetCount(_ sender: Any) {
        if let person = person {
            resetBeerCount(forPerson: person, sender: self)
        }
    }
}

private extension PersonContentViewController {
    
    func setupUI() {
        if isLoading {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        
        countLabel.isHidden = isLoading
        addButton.isEnabled = !isLoading && person != nil
        subtractButton.isEnabled = !isLoading && person != nil
        resetButton.isEnabled = !isLoading && person != nil

        countLabel.text = "\(person?.beerCount ?? 0)"
        
        if canResetCounter && subtractButton.superview == nil {
            buttonsStackView.addArrangedSubview(subtractButton)
        }
        else if !canResetCounter && subtractButton.superview != nil {
            buttonsStackView.removeArrangedSubview(subtractButton)
            subtractButton.removeFromSuperview()
        }
        
        if canResetCounter && resetButton.superview == nil {
            buttonsStackView.addArrangedSubview(resetButton)
        }
        else if !canResetCounter && resetButton.superview != nil {
            buttonsStackView.removeArrangedSubview(resetButton)
            resetButton.removeFromSuperview()
        }
    }
}
