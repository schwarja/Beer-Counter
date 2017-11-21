//
//  PersonEmptyViewController.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PersonEmptyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var text: String = "" {
        didSet {
            if isViewLoaded {
                titleLabel.text = text
            }
        }
    }

}

