//
//  PersonCell.swift
//  BeerCounter
//
//  Created by Jan on 17/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    func configure(withPerson person: Person) {
        textLabel?.text = person.name
        detailTextLabel?.text = "\(person.beerCount)"
    }
}
