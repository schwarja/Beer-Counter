//
//  PersonContainerViewController.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PersonContainerViewController: UIViewController {
    
    var person: Person? {
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

}
private extension PersonContainerViewController {
    
    func setupUI() {
        navigationItem.title = person == nil ? "Person Detail" : person!.name
    }
}
