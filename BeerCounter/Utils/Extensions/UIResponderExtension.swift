//
//  UIResponderExtension.swift
//  BeerCounter
//
//  Created by Jan on 16/11/2017.
//  Copyright © 2017 schwarja. All rights reserved.
//

import UIKit

extension UIResponder {
    
    @objc func showPerson(person: Person, sender: Any?) {
        coordinatingResponder?.showPerson(person: person, sender: sender)
    }
    
    @objc func addBeer(toPerson person: Person, sender: Any?) {
        coordinatingResponder?.addBeer(toPerson: person, sender: sender)
    }
    
    @objc func subtractBeer(forPerson person: Person, sender: Any?) {
        coordinatingResponder?.subtractBeer(forPerson: person, sender: sender)
    }
    
    @objc func resetBeerCount(forPerson person: Person, sender: Any?) {
        coordinatingResponder?.resetBeerCount(forPerson: person, sender: sender)
    }

    @objc func addPerson(sender: Any?) {
        coordinatingResponder?.addPerson(sender: sender)
    }
    
    @objc func deletePerson(person: Person, sender: Any?) {
        coordinatingResponder?.deletePerson(person: person, sender: sender)
    }

    @objc func toggleAdminLogin(sender: Any?) {
        coordinatingResponder?.toggleAdminLogin(sender: sender)
    }
}
